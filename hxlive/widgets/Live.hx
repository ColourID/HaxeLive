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

import hxlive.utils.widgets.Alignment;

class Live
{

    private var __app:App;
    private var __mainFrame:Frame;
    private var __mainContent:Panel;
    private var __clientWidth:Int;
    private var __clientHeight:Int;
    private var __menuBar:MenuBar;
    private var data:Dynamic;
    private var menuData:Dynamic;
    
    private var _lastTime:Date;
    private var _cTime:Date;
    private var _file:String;
    private var _configFile:String;
    private var _activeFiles:Array<FileTimeInfo>;
    
    public function new(config:String)
    {
        __app = new App();
        __app.init();

        __mainFrame = new Frame(null, "HaxeLive");
        __mainFrame.show(true);
        __mainFrame.setSize( -1, -1, -1, -1);
        __mainFrame.setClientSize(800, 600);
        __mainFrame.bind(EventType.CLOSE_WINDOW, function(e:Event) {
            if (__mainContent != null)
                __mainContent.destroy();
            
            __mainFrame.destroy();
        });
        
        __menuBar = new MenuBar();
        __mainFrame.setMenuBar(__menuBar);
        
        __clientWidth = 800;
        __clientHeight = 600;
        
        _lastTime = Date.now();
        _activeFiles = [];
        
        _configFile = config;
        
        update();
        
        __app.run();
        __app.exit();
    }
    
    private function setupConfig(config:String)
    {
        var configData:Dynamic = Json.parse(File.getContent(config));
        _file = configData.file;
        menuData = configData.menu;
        
        data = Json.parse(File.getContent(_file));

        if (_activeFiles == [])
            _activeFiles.push(new FileTimeInfo(_configFile, Date.now()));
    }
    
    private function update()
    {
        if (__mainContent != null)
            __mainContent.destroyChildren();
        else
            __mainContent = new Panel(__mainFrame);
        
        __mainContent.setSize(0, 0, __clientWidth, __clientHeight);
        
        __menuBar = new MenuBar();
        __mainFrame.setMenuBar(__menuBar);
        
        setupConfig(_configFile);
        
        SceneGen.generate(data, __mainContent);
        
        if (menuData != null)
        {
            for (i in 0...menuData.length)
            {
                SceneGen.createMenu(__menuBar, menuData[i]);
            }
        }
        
        var btnUpdate = new Button(__mainContent, "Update");
        Alignment.alignBottom(btnUpdate, 5);
        Alignment.centerHorizontally(btnUpdate);
        
        btnUpdate.bind(EventType.BUTTON, function(e:Event)
        {
            update();
        });
    }
    
    
}