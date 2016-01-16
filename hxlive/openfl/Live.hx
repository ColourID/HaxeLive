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
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

import hxlive.DateCompare;

import haxe.Json;
import haxe.CallStack;

#if telemetry
import openfl.profiler.Telemetry;
#end

#if sys
import sys.io.File;
import sys.FileSystem;

import dialogs.Dialogs;
#end

class Live extends Sprite
{
    
    private var _lastTime:Date;
    private var _file:String;
    private var _configFile:String;
    private var _activeFiles:Array<FileTimeInfo>;
    private var data:Dynamic;
    
	public function new(config:String)
    {
        super();
        
        _lastTime = Date.now();
        _activeFiles = [];
        
        _configFile = config;
        
        setupConfig(config);
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, stage_onKeyUp);
    }
    
    private function stage_onKeyUp(e:KeyboardEvent):Void 
    {
        if (e.keyCode == Keyboard.E && e.ctrlKey)
        {
            var result = Dialogs.save("Export...", { ext: "hx", desc: "Haxe source file" } );
            
            if (result != null)
            {
                Exporter.export(_file, result, "scenes");
            }
        }
    }
    
    private function setupConfig(config:String)
    {
        var configData:Dynamic = Json.parse(Assets.getText(config));
        _file = configData.file;
        
        #if sys
        data = Json.parse(File.getContent(_file));
        #else
        data = Json.parse(Assets.getText(_file));
        #end
        
        _activeFiles.push(new FileTimeInfo(_configFile, Date.now()));
    }
    
    private function enterFrame(e:Event):Void 
    {
        #if sys
        var requireChange = false;
        
        var time = FileSystem.stat(_file).mtime;
        
        if (DateCompare.compare(time, _lastTime) != 0)
        {
            _lastTime = time;
            time = null;
            
            data = Json.parse(File.getContent(_file));
            
            requireChange = true;
        }
        
        for (i in 0..._activeFiles.length)
        {
            if (requireChange)
                break;
            
            var mtime = FileSystem.stat(_activeFiles[i].file).mtime;
            
            if (DateCompare.compare(mtime, _activeFiles[i].time) != 0)
            {
                _activeFiles[i].time = mtime;
                mtime = null;
                
                if (_activeFiles[i].file == _configFile)
                    setupConfig(_configFile);
                
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