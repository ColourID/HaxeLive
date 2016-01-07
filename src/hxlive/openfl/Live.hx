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

import hscript.Expr;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Application;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.DOMSprite;
import openfl.display.DirectRenderer;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.FPS;
import openfl.display.FrameLabel;
import openfl.display.GradientType;
import openfl.display.InteractiveObject;
import openfl.display.InterpolationMethod;
import openfl.display.JPEGEncoderOptions;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.PNGEncoderOptions;
import openfl.display.Shape;
import openfl.display.SimpleButton;
import openfl.display.SpreadMethod;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageDisplayState;
import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.display.Tilesheet;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardTransferMode;
import openfl.events.AccelerometerEvent;
import openfl.events.ActivityEvent;
import openfl.events.AsyncErrorEvent;
import openfl.events.ContextMenuEvent;
import openfl.events.DataEvent;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.FullScreenEvent;
import openfl.events.GameInputEvent;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.events.ProgressEvent;
import openfl.events.SampleDataEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.TextEvent;
import openfl.events.TimerEvent;
import openfl.events.TouchEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Orientation3D;
import openfl.geom.PerspectiveProjection;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.geom.Utils3D;
import openfl.geom.Vector3D;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.FontType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextLineMetrics;
import openfl.ui.GameInput;
import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;
import openfl.ui.Keyboard;
import openfl.ui.Mouse;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;

import hxlive.DateCompare;

import haxe.Json;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Live extends Sprite
{
    
    private var _lastTime:Array<Date>;
    private var _file:String;
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
            try
            {
                var content = SceneGen.generate(data);
                removeChildren();
                addChild(content);
                
                requireChange = false;
            }
            catch (msg:String)
            {
                trace(msg);
            }
        }
        #end
    }
    
    

    
    
}