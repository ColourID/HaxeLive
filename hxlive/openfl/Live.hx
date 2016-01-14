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

import openfl.Assets;
import openfl.events.Event;
import openfl.display.Sprite;

import hxlive.DateCompare;

import haxe.Json;
import haxe.CallStack;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Live extends Sprite
{
    
    private var _lastTime:Date;
    private var _file:String;
    private var _activeFiles:Array<FileTimeInfo>;
    private var data:Dynamic;
    
	public function new(file:String)
    {
        super();
        
        _file = file;
        data = Json.parse(Assets.getText(_file));
        
        _lastTime = Date.now();
        _activeFiles = [];
      
        setupLinkedFiles(file);
        
        trace(_activeFiles);
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    private function enterFrame(e:Event):Void 
    {
        #if sys
        var requireChange = false;
        
        var time = FileSystem.stat(_file).mtime;
        
        if (DateCompare.compare(time, _lastTime) != 0)
        {
            _lastTime = time;
            
            data = Json.parse(Assets.getText(_file));
            
            requireChange = true;
        }
        
        for (i in 0..._activeFiles.length)
        {
            var file = _activeFiles[i];
            
            var mtime = FileSystem.stat(file.file).mtime;
            
            if (DateCompare.compare(mtime, file.time) != 0)
            {
                file.time = mtime;
                
                requireChange = true;
            }
        }
        
        if (requireChange)
        {
            try
            {
                var content = SceneGen.generate(data);
                removeChildren();
                addChild(content);
                
                requireChange = false;
            }
            catch (msg:String)
            {
                trace(CallStack.toString(CallStack.callStack()));
                trace(msg);
            }
        }
        #end
    }

    private function setupLinkedFiles(file:String)
    {
        var parsed:Dynamic = Json.parse(Assets.getText(file));
        
        _activeFiles.push(new FileTimeInfo(file, Date.now()));
        
        if (parsed.theme != null)
        {
            _activeFiles.push(new FileTimeInfo(parsed.theme, Date.now()));
        }
        
        if (parsed.requires != null)
        {
            for (i in 0...parsed.requires.length)
                setupLinkedFiles(parsed.requires[i]);
        }
    }
    
}

class FileTimeInfo
{
    
    public var file:String;
    public var time:Date;
    
    public function new (file:String, time:Date)
    {
        this.time = time;
        this.file = file;
    }
    
}