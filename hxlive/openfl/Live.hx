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

import haxe.FileSystemExtender;
import hxlive.utils.Color;

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
    private var _cTime:Date;
    private var _file:String;
    private var _configFile:String;
    private var _activeFiles:Array<FileTimeInfo>;
    private var _notified:Bool;
    private var data:Dynamic;
    
    private var _inputResult:String;
    private var _isFrozen:Bool;
    
	public function new(config:String)
    {
        super();
        
        _lastTime = Date.now();
        _activeFiles = [];
        
        _configFile = config;
        
        setupConfig(config);
        
        addEventListener(Event.ENTER_FRAME, onEnter);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, stage_onKeyUp);
    }
    
    private function activateNotify():Void 
    {   
        var notify = new Notification("to Export", "CTRL+E");
        hxlive.utils.Location.screenFromLeft(notify, -200);
        notify.y = 2;
        
        addChild(notify);
        notify.display(2000, { x: 2, y: 2 } );
    }
    
    private function displayMessage(message:String, backColor:Color)
    {
        var notify = new Notification(message, "", 2, backColor);
        hxlive.utils.Location.screenFromBottom(notify, 200);
        
        addChild(notify);
        notify.display(5000, { x: notify.x, y: notify.y - 230 } );
    }
    
    private function stage_onKeyUp(e:KeyboardEvent):Void
    {
        if (e.keyCode == Keyboard.E && e.ctrlKey)
        {
            var result = Dialogs.save("Export...", { ext: "hx", desc: "Haxe source file" } );
            
            if (result != null)
            {
                var dir = FileSystemExtender.getRootDir(result);
                if (dir != "" && FileSystem.exists(dir))
                {
                    var msg = Exporter.export(data, result);
                    switch (msg)
                    {
                        case "SUCCESS":
                            displayMessage("Export successful.", Color.green());
                        default:
                            displayMessage(msg, Color.red());
                    }
                }
                else
                {
                    var message = 'The path to the directory: "$dir" does not exist.';
                    displayMessage(message, Color.red());
                }
                
            }
        }
    }
    
    private function setupConfig(config:String)
    {
        var configData:Dynamic = Json.parse(Assets.getText(config));
        _file = configData.file;
        
        if (configData.export_options != null)
            Exporter.options = configData.export_options;
        
        #if sys
        data = Json.parse(File.getContent(_file));
        #else
        data = Json.parse(Assets.getText(_file));
        #end
        
        if (_activeFiles == [])
            _activeFiles.push(new FileTimeInfo(_configFile, Date.now()));
    }
    
    private function readChar(i:Int)
    {
        var char = String.fromCharCode(i);
        
        if (char == "\n")
        {
            switch (_inputResult)
            {
                case "FREEZE": _isFrozen = true;
                case "UNFREEZE": _isFrozen = false;
            }
            
            _inputResult = "";
        }
        else
            _inputResult += char;
    }
    
    private function onEnter(e:Event):Void 
    {
        readChar(Sys.getChar(false));
        
        if (_isFrozen)
            return;
    
        #if sys
        var requireChange = false;
        
        _cTime = FileSystem.stat(_file).mtime;
        
        if (DateCompare.compare(_cTime, _lastTime) != 0)
        {
            _lastTime = _cTime;
            
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
                
                if (!_notified)
                {
                    _notified = true;
                    activateNotify();
                }
                
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