/*

The MIT License (MIT)

Copyright (c) 2015 tienery

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package hxlive.openfl;
import haxe.Template;
import haxe.Json;
import hxlive.openfl.Exporter.ExportOptions;
import hxlive.openfl.Exporter.Sizer;
import hxlive.utils.Color;

#if sys
import sys.io.File;
#end

class Exporter
{
    
    private static var __imports:Array<String>;
    private static var __styles:Map<String, Dynamic>;
    private static var __parent:String;
    private static var locator:Array<Dynamic>;
    
    public static var options:ExportOptions;
    
    public static function export(data:Dynamic, target:String):String
    {
        var successful:String = "ERROR";
        
        try
        {
            if (options == null)
                options = { useResize: true };
            
            __imports = [];
            __styles = new Map<String, Dynamic>();
            __parent = "";
            
            generateImports(data.contents);
            
            var result:Dynamic = { instanceType: data.instanceType };
            
            locator = [];
            
            //Setup imports.
            var imports = new Array<Dynamic>();
            for (i in 0...__imports.length)
                imports.push( { value: __imports[i] } );
            
            result.imports = imports;
            
            result.inits = [];
            result.sizers = [];
            result.contents = [];
            
            //Setup theme for the instance.
            if (data.theme != null)
            {
                var theme:Dynamic = Json.parse(File.getContent(data.theme));
                
                var styles = Reflect.fields(theme);
                
                for (i in 0...styles.length)
                {
                    var s:Dynamic = Reflect.field(theme, styles[i]);
                    if (s.type == "spritesheet")
                    {
                        result.theme = data.theme;
                    }
                    
                    __styles.set(styles[i], s);
                }
            }
            
            //Setup flow for `this` instance.
            {
                var loc:Sizer = {
                    name: "this",
                    location:null,
                    padding:data.padding
                };
                
                if (data.flow != null)
                {
                    loc.location = flow(data.flow == 0);
                    
                    locator.push( { code: getLocationCode(loc) } );
                }
            }
            
            generateSpriteCode(result, data);
            
            result.useResize = options.useResize;
            result.sizers = locator;
            
            var t = new Template(File.getContent("templates/openfl/Class.txt"));
            File.saveContent(target, t.execute(result));
        }
        catch (msg:String)
        {
            return successful += msg;
        }
        
        return successful = "SUCCESS";
    }
    
    private static function generateSpriteCode(results:Dynamic, data:Dynamic)
    {
        var contents = new Array<ContentItem>();
        var inits = new Array<Dynamic>();
        
        //Generate the code for each item in contents.
        for (i in 0...data.contents.length)
        {
            var item:Dynamic = data.contents[i];
            
            if (item.name == null)
            {
                item.name = item.type.charAt(0).toLowerCase()
                    + item.type.substr(1) + i;
            }
            
            var style:Dynamic = { };
            
            if (item.styleName != null)
            {
                style = __styles.get(item.styleName);
            }
            
            if (item.type == "Text")
            {
                if (Reflect.fields(style).length == 0)
                {
                    style.fontFile = item.fontFile;
                    style.fontSize = item.fontSize;
                    style.fontColor = Color.getColorValue(item.fontColor);
                }
                
                item.style = style;
                
                item.type = "TextField";
                inits.push( { code: initTextField(item) } );
            }
            else if (item.type == "Bitmap")
            {
                if (Reflect.fields(style).length == 0)
                {
                    style.bitmapSource = item.bitmapSource;
                }
                
                item.style = style;
                
                inits.push( { code: initBitmap(item) } );
            }
            else if (item.type == "SimpleButton")
            {
                var usingSpritesheet = (style.type == "spritesheet");
                if (usingSpritesheet)
                {
                    item.usingSpritesheet = usingSpritesheet;
                    
                    if (item.styleValue[0] != null)
                        style.upState = item.styleValue[0];
                    
                    if (item.styleValue[1] != null)
                        style.overState = item.styleValue[1];
                    
                    if (item.styleValue[2] != null)
                        style.downState = item.styleValue[2];
                    
                    if (item.styleValue[3] != null)
                        style.hitTestState = item.styleValue[3];
                }
                else
                {
                    if (item.upStateSource != null)
                        style.upState = item.upStateSource;
                    
                    if (item.overStateSource != null)
                        style.overState = item.overStateSource;
                    
                    if (item.downStateSource != null)
                        style.downState = item.downStateSource;
                    
                    if (item.hitTestStateSource != null)
                        style.hitTestState = item.hitTestStateSource;
                }
                
                item.style = style;
                
                inits.push( { code: initSimpleButton(item) } );
            }
            else if (item.type == "Sprite")
            {   
                inits.push( { code: initSprite(results, item) } );
            }
            
            contents.push( { name: item.name, type: item.type } );
        }
        
        //Setup location for each object in contents
        for (i in 0...data.contents.length)
        {
            var item:Dynamic = data.contents[i];
            
            var loc:Sizer = {
                name:item.name,
                location:null,
                first:(i == 0),
                width:item.width,
                height:item.height,
                x:item.x,
                y:item.y,
                padding:item.padding
            };
            
            if (item.flow != null && item.type == "Sprite")
            {
                loc.location = flow(item.flow == 0);
            }
            else if (item.align != null)
            {
                if (Reflect.isObject(item.align))
                {
                    var edge:Edge = switch (item.align.alignment)
                    {
                        case 0: Left;
                        case 1: Top;
                        case 2: Right;
                        default: Bottom;
                    }
                    loc.location = nextTo(item.align.name, item.align.padding, edge);
                }
                else
                {
                    switch (item.align)
                    {
                        case 4:
                            loc.location = alignCenter;
                        case 5:
                            loc.location = centerVertically;
                        case 6:
                            loc.location = centerHorizontally;
                        default:
                            var edge:Edge = switch(item.align) {
                                case 0 | -1: Left;
                                case 1 | -2: Top;
                                case 2 | -3: Right;
                                default: Bottom;
                            }
                            if (item.align < 0)
                                loc.location = screenEdge(edge);
                            else
                                loc.location = align(edge);
                    }
                }
            }
            else
            {
                if (loc.x == null)
                    loc.x = 0;
                if (loc.y == null)
                    loc.y = 0;
            }
            
            locator.push( { code: getLocationCode(loc) } );
        }
        
        populateResults(results, contents, inits);
    }
    
    private static function populateResults(results:Dynamic, contents:Array<ContentItem>, inits:Array<Dynamic>)
    {
        var index = results.contents.length;
        for (i in 0...contents.length)
        {
            results.contents[index++] = contents[i];
        }
        
        index = results.inits.length;
        for (i in 0...inits.length)
        {
            results.inits[index++] = inits[i];
        }
    }
    
    private static function getLocationCode(data:Sizer):String {
        var result:String = "";
        var name:String = data.name;
        var spaces:String = "";
        
        if (data.first)
        {
            if(data.padding == null)
                data.padding = 2;
            result = 'var padding = ${data.padding};\n';
            spaces = "        ";
        }
        
        if (data.width != null)
        {
            result += '$spaces$name.width = ${data.width};\n';
            spaces = "        ";
        }
        if (data.height != null)
        {
            result += '$spaces$name.height = ${data.height};\n';
            spaces = "        ";
        }
        
        if (data.location != null)
        {
            switch (data.location)
            {
                case flow(fromTop):
                    var source:String = (fromTop ? "Top" : "Left");
                    result += '$spaces Flow.flowFrom$source($name, padding);\n';
                case nextTo(otherName, padding, edge):
                    result += '$spaces Location.setLocation${edge.getName()}Of($name, $otherName, $padding);\n';
                case screenEdge(edge):
                    result += '$spaces Location.screenFrom${edge.getName()}($name, padding);\n';
                case align(edge):
                    result += '$spaces Alignment.align${edge.getName()}($name, padding);\n';
                case alignCenter | centerVertically | centerHorizontally:
                    result += '$spaces Alignment.${data.location.getName()}($name);\n';
            }
            spaces = "        ";
        }
        else
        {
            if (data.x != null)
            {
                result += '$spaces$name.x = ${data.x};\n';
                spaces = "        ";
            }
            if (data.y != null)
            {
                result += '$spaces$name.y = ${data.y};\n';
                spaces = "        ";
            }
        }
        
        return result;
    }
    
    private static function initSprite(results:Dynamic, data:Dynamic):String
    {
        var result = "";
        var spaces = "        ";
        
        result += '${data.name} = new Sprite();\n';
        
        if (__parent != "")
            result += '$spaces$__parent.addChild(${data.name});\n';
        else
            result += '$spaces addChild(${data.name});\n';
            
        __parent = '${data.name}';
        
        generateSpriteCode(results, data);
        
        __parent = "";
        
        return result;
    }
    
    private static function initSimpleButton(data:Dynamic):String
    {
        if (data.style == null)
            return "";
        
        data.alpha = data.alpha != null ? data.alpha : 1;
        data.chain = __parent;
        
        var t = new Template(File.getContent("templates/openfl/SimpleButton.txt"));
        return t.execute(data);
    }
    
    private static function initBitmap(data:Dynamic):String
    {
        if (data.bitmapSource == null)
            return "";
        
        data.alpha = data.alpha != null ? data.alpha : 1;
        data.chain = __parent;
        
        var t = new Template(File.getContent("templates/openfl/Bitmap.txt"));
        return t.execute(data);
    }
    
    private static function initTextField(data:Dynamic):String
    {
        switch (data.autoSize)
        {
            case 0: data.autoSize = "TextFieldAutoSize.NONE";
            case 1: data.autoSize = "TextFieldAutoSize.LEFT";
            case 2: data.autoSize = "TextFieldAutoSize.RIGHT";
            case 3: data.autoSize = "TextFieldAutoSize.CENTER";
            default: data.autoSize = "TextFieldAutoSize.NONE";
        }
        
        switch (data.fieldType)
        {
            case 0: data.fieldType = "TextFieldType.DYNAMIC";
            case 1: data.fieldType = "TextFieldType.INPUT";
            default: data.fieldType = "TextFieldType.DYNAMIC";
        }
        
        data.selectable = data.selectable != null ? data.selectable : false;
        data.multiline = data.multiline != null ? data.multiline : false;
        data.wordWrap = data.wordWrap != null ? data.wordWrap : false;
        data.alpha = data.alpha != null ? data.alpha : 1;
        data.text = data.text != null ? data.text : "Example Text Field";
        data.chain = __parent;
        
        var t = new Template(File.getContent("templates/openfl/TextField.txt"));
        return t.execute(data);
    }
    
    private static function generateImports(content:Dynamic)
    {
        if (content != null)
        {
            for (i in 0...content.length)
            {
                var item:Dynamic = content[i];
                
                if (item.type == "Text")
                {
                    addArrayItem("openfl.text.TextField");
                    addArrayItem("openfl.text.TextFieldAutoSize");
                    addArrayItem("openfl.text.TextFieldType");
                    addArrayItem("openfl.text.TextFormat");
                    addArrayItem("openfl.Assets");
                }
                else if (item.type == "Bitmap")
                {
                    addArrayItem("openfl.display.Bitmap");
                    addArrayItem("openfl.display.BitmapData");
                    addArrayItem("openfl.Assets");
                }
                else if (item.type == "SimpleButton")
                {
                    addArrayItem("openfl.display.SimpleButton");
                    addArrayItem("openfl.display.Bitmap");
                    addArrayItem("openfl.Assets");
                }
                else if (item.type == "Sprite")
                {
                    if (item.contents != null)
                        generateImports(item.contents);
                }
            }
        }

        addArrayItem("openfl.display.Sprite");
        addArrayItem("hxlive.utils.openfl.Alignment");
        addArrayItem("hxlive.utils.openfl.Flow");
        addArrayItem("hxlive.utils.openfl.Location");
        addArrayItem("hxlive.utils.openfl.SpriteMap");
    }
    
    private static function addArrayItem(value:String)
    {
        for (i in 0...__imports.length)
            if (__imports[i] == value)
                return;
        
        __imports.push(value);
    }

}

typedef ExportOptions = {
    @:optional var useResize:Bool;
}

typedef Sizer = {
    var name:String;
    @:optional var location:Position;
    @:optional var width:Int;
    @:optional var height:Int;
    @:optional var x:Int;
    @:optional var y:Int;
    @:optional var first:Bool;
    @:optional var padding:Int;
}

enum Position {
    flow(fromTop:Bool);
    nextTo(name:String, padding:Int, edge:Edge);
    screenEdge(edge:Edge);
    align(edge:Edge);
    centerVertically;
    centerHorizontally;
    alignCenter;
}

enum Edge {
    Left;
    Top;
    Right;
    Bottom;
}

typedef ContentItem = {
    var name:String;
    var type:String;
}
