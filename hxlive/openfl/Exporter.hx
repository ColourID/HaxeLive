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
import hxlive.utils.Color;

#if sys
import sys.io.File;
#end

class Exporter
{
    
    private static var __imports:Array<String>;
    private static var __styles:Map<String, Dynamic>;
    
    public static var options:ExportOptions;
    
    public static function export(data:Dynamic, target:String)
    {
        Sys.println("0");
        generateImports(data.contents);
        
        Sys.println("6");
        var result:Dynamic = { };
        var contents = new Array<Dynamic>();
        var inits = new Array<Dynamic>();
        var locator = new Array<String>();
        
        Sys.println("7");
        if (data.theme != null)
        {
            var theme:Dynamic = Json.parse(File.getContent(data.theme));
            
            var styles = Reflect.fields(theme);
            
            for (i in 0...styles.length)
            {
                var s:Dynamic = Reflect.field(theme, styles[i]);
                if (s.type == "spritesheet")
                {
                    result.usingSpritesheet = true;
                    result.sheet = s;
                }
                
                __styles.set(styles[i], s);
            }
        }
        
        Sys.println("8");
        for (i in 0...data.contents.length)
        {
            var item:Dynamic = data.contents[i];
            
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
                
                Reflect.setField(item, "style", style);
                
                item.type = "TextField";
                inits.push( { code: initTextField(item) } );
            }
            else if (item.type == "Bitmap")
            {
                if (Reflect.fields(style).length == 0)
                {
                    style.bitmapSource = item.bitmapSource;
                }
                
                Reflect.setField(item, "style", style);
                
                inits.push( { code: initBitmap(item) } );
            }
            else if (item.type == "SimpleButton")
            {
                var usingSpritesheet = (style.type == "spritesheet");
                if (usingSpritesheet)
                {
                    Reflect.setField(item, "usingSpritesheet", usingSpritesheet);
                    
                    if (item.styleValue[0] != null)
                        Reflect.setField(style, "upState", item.styleValue[0]);
                    
                    if (item.styleValue[1] != null)
                        Reflect.setField(style, "overState", item.styleValue[1]);
                    
                    if (item.styleValue[2] != null)
                        Reflect.setField(style, "downState", item.styleValue[2]);
                    
                    if (item.styleValue[3] != null)
                        Reflect.setField(style, "hitTestState", item.styleValue[3]);
                }
                
                Reflect.setField(item, "style", style);
                
                inits.push( { code: initSimpleButton(item) } );
            }
            
            contents.push( { name: item.name, type: item.type } );
        }
        Sys.println("9");
        result.contents = contents;
        
        result.useResize = options.useResize;
        Sys.println("10");
        if (options.useResize)
        {
            for (i in 0...contents.length)
            {
                var item:Dynamic = data.contents[i];
                
                var data:Sizer = null;
                
                if (item.flow != null && item.type == "Sprite")
                {
                    data.flowing = true;
                    data.flow = item.flow;
                }
                else
                {
                    if (item.align != null)
                    {
                        data.alignIsObject = Reflect.isObject(item.align);
                    }
                    
                    data.align = item.align;
                }
                
                data.name = item.name;
                
                if (item.height != null)
                    data.height = item.height;
                
                if (item.width != null)
                    data.width = item.width;
                
                data.x = item.x;
                data.y = item.y;
                
                locator.push(executeLocator(data));
            }
        }
        Sys.println("11");
        result.sizers = locator;
        Sys.println("12");
        var t = new Template(File.getContent("templates/openfl/Class.txt"));
        File.saveContent(target, t.execute(result));
        Sys.println("13");
    }
    
    private static function executeLocator(data:Dynamic):String
    {
        var t = new Template(File.getContent("templates/openfl/Sizer.txt"));
        return t.execute(data);
    }
    
    private static function initSimpleButton(data:Dynamic):String
    {
        if (data.style == null)
            return "";
        
        data.alpha = data.alpha != null ? data.alpha : 1;
        
        var t = new Template(File.getContent("templates/openfl/SimpleButton.txt"));
        return t.execute(data);
    }
    
    private static function initBitmap(data:Dynamic):String
    {
        if (data.bitmapSource == null)
            return "";
        
        data.alpha = data.alpha != null ? data.alpha : 1;
        
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
        
        var t = new Template(File.getContent("templates/openfl/TextField.txt"));
        return t.execute(data);
    }
    
    private static function generateImports(content:Dynamic)
    {
        if (content != null)
        {
            Sys.println("1");
            for (i in 0...content.length)
            {
                var item:Dynamic = content[i];
                
                Sys.println("2");
                if (item.type == "Text")
                {
                    addArrayItem("openfl.text.TextField");
                    addArrayItem("openfl.text.TextFieldAutoSize");
                    addArrayItem("openfl.text.TextFieldType");
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
                Sys.println("3");
            }
        }
        Sys.println("4");
        addArrayItem("hxlive.utils.openfl.Alignment");
        addArrayItem("hxlive.utils.openfl.Flow");
        addArrayItem("hxlive.utils.openfl.Location");
        addArrayItem("hxlive.utils.openfl.SpriteMap");
        Sys.println("5");
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
    @:optional var padding:Int;
    @:optional var width:Int;
    @:optional var height:Int;
    @:optional var x:Int;
    @:optional var y:Int;
    @:optional var flow:Int;
    @:optional var flowing:Bool;
    @:optional var alignIsObject:Bool;
    @:optional var align:Dynamic;
}

typedef Alignment = {
    var name:String;
    var alignment:Int;
    var padding:Int;
}