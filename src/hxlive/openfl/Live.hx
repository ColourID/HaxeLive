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
    
    private var _lastTime:Array<Date>;
    private var _file:String;
    private var _activeFiles:Array<String>;
    private var data:Dynamic;
    
	public function new(file:String)
    {
        super();
        
        _file = file;
        data = Json.parse(Assets.getText(_file));
        
        _lastTime = [];
        
        if (data.requires != null)
        {
            for (i in 0...data.requires.length + 1)
                _lastTime.push(Date.now());
        }
		else
		{
			_lastTime.push(Date.now());
		}
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    private function enterFrame(e:Event):Void 
    {
        #if sys
        var requireChange = false;
        
        var time = FileSystem.stat(_file).mtime;
        
        if (DateCompare.compare(time, _lastTime[0]) != 0)
        {
            _lastTime[0] = time;
            
            data = Json.parse(Assets.getText(_file));
            
            requireChange = true;
        }
        
        if (data.requires != null)
        {
            for (i in 0...data.requires.length)
            {
                var file:Dynamic = data.requires[i];
                
                var mtime = FileSystem.stat(file).mtime;
                
                if (DateCompare.compare(mtime, _lastTime[i + 1]) != 0)
                {
                    _lastTime[i + 1] = mtime;
                    
                    requireChange = true;
                }
            }
        }
        
        if (requireChange)
        {
            //try
            //{
                var content = SceneGen.generate(data);
                removeChildren();
                addChild(content);
                
                requireChange = false;
            //}
            //catch (msg:String)
            //{
                //trace(CallStack.toString(CallStack.callStack()));
                //trace(msg);
            //}
        }
        #end
    }
    
    

    
    
}