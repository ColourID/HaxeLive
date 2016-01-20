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
#if sys

import haxe.Json;
import hxlive.utils.StringBuilder;
import sys.io.File;
import openfl.display.SimpleButton;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class Exporter
{
    
    @:noCompletion private static var _level:Int;
    @:noCompletion private static var _currentProgress:Int;
    @:noCompletion private static var _progressCount:Int;
    @:noCompletion private static var imports:Array<String>;
    @:noCompletion private static var decls:Array<Declaration>;
    @:noCompletion private static var inits:Array<String>;
    @:noCompletion private static var theme:Dynamic;
    @:noCompletion private static var styles:Map<String, Dynamic>;
    
    public static var options:ExportOptions;

    public static function export(file:String, target:String, pkg:String)
    {
        if (options == null)
            options = { useTabChar: false, spaces: 4 };
        
        imports = [];
        decls = [];
        inits = [];
        
        styles = new Map<String, Dynamic>();
        
        var data = Json.parse(File.getContent(file));
        
        _level = 0;
        _progressCount = 0;
        _currentProgress = 0;
        
        Sys.println("Preparing...");
        
        generateImports(imports, data);
        generateDeclarations(decls, data);
        
        _progressCount = imports.length + decls.length;
        
        var results = new StringBuilder("");
        results.eol = "\r\n";
        
        appendLine(results, "package " + pkg + ";");
        
        for (i in 0...imports.length)
        {
            appendLine(results, "import " + imports[i] + ";");
            addProgress();
        }
        
        results.appendLine("");
        appendLine(results, "class " + data.instanceType + " extends Sprite");
        startFolder(results);
        
        for (i in 0...decls.length)
        {
            appendLine(results, "private var _" + decls[i].name + ":" + decls[i].type + ";");
            inits.push(decls[i].name + " = new " + decls[i].type + "();");
            addProgress();
        }
        
        endFolder(results);
        
        File.saveContent(target, results.toString());
        
        Sys.println("\nDone.");
    }
    
    private static function addProgress()
    {
        _currentProgress++;
        var percent:Float = _currentProgress / _progressCount * 100;
        var results = Math.round(percent);
        
        Sys.print("\rProgress: " + results + "%"); 
    }
    
    private static function setupTheme(data:Dynamic)
    {
        if (data.theme != null)
            theme = Json.parse(File.getContent(data.theme));
        
        var styleNames = Reflect.fields(theme);
        
        for (i in 0...styleNames.length)
            styles.set(styleNames[i], Reflect.field(styleNames[i]));
    }
    
    private static function generateImports(arr:Array<String>, data:Dynamic)
    {   
        if (data.contents != null)
        {
            for (i in 0...data.contents.length)
            {
                var obj = data.contents[i];
                
                if (obj.type == "SimpleButton")
                {
                    addValue(arr, "openfl.display.SimpleButton");
                    addValue(arr, "openfl.display.Bitmap");
                    addValue(arr, "openfl.Assets");
                }
                else if (obj.type == "Bitmap")
                {
                    addValue(arr, "openfl.display.Bitmap");
                    addValue(arr, "openfl.Assets");
                }
                else if (obj.type == "Text")
                {
                    addValue(arr, "openfl.text.TextField");
                    addValue(arr, "openfl.text.TextFieldAutoSize");
                    addValue(arr, "openfl.text.TextFieldType");
                }
            }
        }
    }
    
    private static function generateDeclarations(arr:Array<Declaration>, data:Dynamic)
    {   
        if (data.contents != null)
        {
            for (i in 0...data.contents.length)
            {
                var obj:Dynamic = data.contents[i];
                var decl:Declaration = { };
                
                if (obj.name == null)
                    throw "Object's must have names to be exported.";
                
                decl.name = obj.name;
                
                if (obj.type == "Text")
                    decl.type = "TextField";
                else
                    decl.type = obj.type;
                
                setupInits(obj);
                
                arr.push(decl);
            }
        }
    }
    
    private static function setupInits(obj:Dynamic)
    {
        var fields = Reflect.fields(obj);
        
        var type:String = obj.type;
        
        for (i in 0...fields.length)
        {
            var f = fields[i];
            
            if (f == "type")
                continue;
            
            if (f == "styleName")
            {
                
                
                if (type == "Text")
                {
                    
                }
            }
        }
    }
    
    private static function startFolder(sb:StringBuilder)
    {
        appendLine(sb, "{");
        _level++;
    }
    
    private static function endFolder(sb:StringBuilder)
    {
        _level--;
        if (_level < 0)
            _level = 0;
        
        appendLine(sb, "}");
    }
    
    private static function appendLine(sb:StringBuilder, value:String)
    {
        var results = "";
        
        var tabsRemaining = 0;
        if (!options.useTabChar)
            tabsRemaining = options.spaces * _level;
        else
            tabsRemaining = _level;
        
        while (tabsRemaining > 0)
        {
            if (options.useTabChar)
                results += "\t";
            else
                results += " ";
            
            tabsRemaining--;
        }
        
        sb.appendLine(results + value);
    }
    
    private static function addValue(arr:Array<String>, value:String)
    {
        for (i in 0...arr.length)
            if (arr[i] == value)
                return;
        
        arr.push(value);
    }
    
    private static function addDecl(arr:Array<Declaration>, value:Declaration)
    {
        for (i in 0...arr.length)
            if (arr[i].name == value.name)
                return;
        
        arr.push(value);
    }
    
}

typedef Declaration = {
    @:optional var name:String;
    @:optional var type:String;
}

typedef ExportOptions = {
    var useTabChar:Bool;
    var spaces:Int;
}

#end