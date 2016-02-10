/*

The MIT License (MIT)

Copyright (c) 2016 Colour Multimedia Enterprises

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

package hxlive.widgets;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;

import hx.widgets.*;

import cpp.vm.Thread;

class Live
{

    private var __app:App;
    private var __mainFrame:Frame;
    private var __mainContent:Panel;
    private var __clientWidth:Int;
    private var __clientHeight:Int;
    
    private var _running:Bool;
    private var _lastTime:Date;
    private var _cTime:Date;
    private var _file:String;
    private var _configFile:String;
    private var _activeFiles:Array<FileTimeInfo>;
    private var data:Dynamic;
    
    public function new(config:String)
    {
        __app = new App();
        __app.init();

        __mainFrame = new Frame(null, "HaxeLive");
        __mainFrame.show(true);
        __mainFrame.setSize( -1, -1, -1, -1);
        __mainFrame.setClientSize(800, 600);
        __mainFrame.bind(EventType.CLOSE_WINDOW, function(e:Event) {
            _running = false;
            
            if (__mainContent != null)
                __mainContent.destroy();
            
            __mainFrame.destroy();
        });
        
        __clientWidth = 800;
        __clientHeight = 600;
        
        __mainContent = new Panel(__mainFrame);
        __mainContent.setSize(0, 0, __clientWidth, __clientHeight);
        
        _lastTime = Date.now();
        _activeFiles = [];
        
        _configFile = config;
        
        setupConfig(config);
        
        
        
        __app.run();
        __app.exit();
    }
    
    private function setupConfig(config:String)
    {
        var configData:Dynamic = Json.parse(File.getContent(config));
        _file = configData.file;
        
        data = Json.parse(File.getContent(_file));

        if (_activeFiles == [])
            _activeFiles.push(new FileTimeInfo(_configFile, Date.now()));
    }
    
    private function processEvents()
    {
        Sys.sleep(0.1);
        
        if (checkFileState())
        {
            try
            {
                __mainContent = new Panel(__mainFrame);
                __mainContent.setSize(0, 0, __clientWidth, __clientHeight);
                
                SceneGen.generate(data, __mainContent);
            }
            catch (msg:String)
            {
                trace(msg);
            }
        }
        
        if (_running)
            processEvents();
    }
    
    private function checkFileState()
    {
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
        
        return requireChange;
    }
    
}