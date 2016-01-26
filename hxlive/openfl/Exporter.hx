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
        
        if (options == null)
            options = { useResize: true };
        
        __imports = [];
        __styles = new Map<String, Dynamic>();
        
        generateImports(data.contents);
        
        Sys.println("6");
        var result:Dynamic = { instanceType: data.instanceType };
        var contents = new Array<ContentItem>();
        var inits = new Array<Dynamic>();
        var locator = new Array<Dynamic>();
        
        var imports = new Array<Dynamic>();
        for (i in 0...__imports.length)
            imports.push( { value: __imports[i] } );
        
        result.imports = imports;
        
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
                    s.setup = Json.stringify(s.setup);
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
                    if (item.bmpUpStateSource != null)
                        style.upState = item.bmpUpStateSource;
                    
                    if (item.bmpOverStateSource != null)
                        style.overState = item.bmpOverStateSource;
                    
                    if (item.bmpDownStateSource != null)
                        style.downState = item.bmpDownStateSource;
                    
                    if (item.bmpHitTestStateSource != null)
                        style.hitTestState = item.bmpHitTestStateSource;
                }
                
                item.style = style;
                
                inits.push( { code: initSimpleButton(item) } );
            }
            
            contents.push( { name: item.name, type: item.type } );
        }
        Sys.println("9");
        result.contents = contents;
        result.inits = inits;
        
        result.useResize = options.useResize;
        Sys.println("10");
        if (options.useResize)
        {
            for (i in 0...data.contents.length)
            {
                Sys.println("11");
                var item:Dynamic = data.contents[i];
                
                var data:Sizer = {
                    name:item.name,
                    location:alignCenter,
                    first:(i == 0),
                    width:item.width,
                    height:item.height,
                    x:item.x,
                    y:item.y
                };
                
                if (item.flow != null && item.type == "Sprite")
                {
                    data.location = flow(item.flow == 0);
                }
                else
                {
                    switch(item.align) {
                        case {alignment:align, name:name, padding:padding}:
                            var edge:Edge = switch(align) {
                                case 0: Left;
                                case 1: Top;
                                case 2: Right;
                                default: Bottom;
                            }
                            data.location = nextTo(name, padding, edge);
                        case 4:
                            data.location = alignCenter;
                        case 5:
                            data.location = centerVertically;
                        case 6:
                            data.location = centerHorizontally;
                        default:
                            var edge:Edge = switch(item.align) {
                                case 0 | -1: Left;
                                case 1 | -2: Top;
                                case 2 | -3: Right;
                                default: Bottom;
                            }
                            if(item.align < 0) {
                                data.location = screenEdge(edge);
                            } else {
                                data.location = align(edge);
                            }
                    }
                }
                
                Sys.println("11");
                locator.push( { code: getLocationCode(data) } );
            }
        }
        Sys.println("11");
        result.sizers = locator;
        Sys.println("12");
        var t = new Template(File.getContent("templates/openfl/Class.txt"));
        File.saveContent(target, t.execute(result));
        Sys.println("13");
    }
    
    public static function getLocationCode(data:Sizer):String {
		var result:String = "";
		var name:String = data.name;
		
		if(data.first) {
			if(data.padding == null) {
				data.padding = 2;
			}
			result = 'var padding = ${data.padding};\n        ';
		}
		
		if(data.width != null) {
			result += '$name.width = ${data.width};\n        ';
		}
		if(data.height != null) {
			result += '$name.height = ${data.height};\n        ';
		}
		
		switch(data.location) {
			case flow(fromTop):
				var source:String = (fromTop ? "Top" : "Left");
				result += 'Flow.flowFrom$source($name, padding);\n        ';
			case nextTo(otherName, padding, edge):
				result += 'Location.setLocation${edge.getName()}Of($name, getChildByName($otherName), $padding);\n        ';
			case align(edge):
				result += 'Alignment.align${edge.getName()}($name, ${data.padding});\n        ';
			default:
				result += 'Alignment.${data.location.getName()}($name);\n        ';
		}
		
		if(data.x != null) {
			result += '$name.x = ${data.x};\n        ';
		}
		if(data.y != null) {
			result += '$name.y = ${data.y};\n        ';
		}
		
		return result;
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
    var location:Location;
    @:optional var width:Int;
    @:optional var height:Int;
    @:optional var x:Int;
    @:optional var y:Int;
    @:optional var first:Bool;
}

enum Location {
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
