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

import hscript.Interp;
import hscript.Parser;

import hxlive.DateCompare;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Live extends Sprite
{
    
    private var _parser:Parser;
    private var _interp:Interp;
    private var _lastTime:Date;
    private var _file:String;
    
	public function new(file:String, addTypes:Array<Dynamic> = null)
    {
        super();
        
        _parser = new Parser();
        _interp = new Interp();
        
        _file = file;
        
        _parser.allowJSON = true;
        _parser.allowTypes = true;
        
        _lastTime = Date.now();
        
        if (addTypes != null)
        {
            for (i in 0...addTypes.length)
            {   
                if (i % 2 == 1)
                    continue;
                
                _interp.variables.set(addTypes[i], addTypes[i + 1]);
            }
        }
        
        _interp.variables.set("Assets", Assets);
        _interp.variables.set("Lib", Lib);
        _interp.variables.set("Application", Application);
        _interp.variables.set("Bitmap", Bitmap);
        _interp.variables.set("BitmapData", BitmapData);
        _interp.variables.set("BitmapDataChannel", BitmapDataChannel);
        _interp.variables.set("BlendMode", BlendMode);
        _interp.variables.set("CapsStyle", CapsStyle);
        _interp.variables.set("DOMSprite", DOMSprite);
        _interp.variables.set("DirectRenderer", DirectRenderer);
        _interp.variables.set("DisplayObject", DisplayObject);
        _interp.variables.set("DisplayObjectContainer", DisplayObjectContainer);
        _interp.variables.set("FPS", FPS);
        _interp.variables.set("FrameLabel", FrameLabel);
        _interp.variables.set("GradientType", GradientType);
        _interp.variables.set("InteractiveObject", InteractiveObject);
        _interp.variables.set("InterpolationMethod", InterpolationMethod);
        _interp.variables.set("JPEGEncoderOptions", JPEGEncoderOptions);
        _interp.variables.set("JointStyle", JointStyle);
        _interp.variables.set("LineScaleMode", LineScaleMode);
        _interp.variables.set("PNGEncoderOptions", PNGEncoderOptions);
        _interp.variables.set("Shape", Shape);
        _interp.variables.set("SimpleButton", SimpleButton);
        _interp.variables.set("SpreadMethod", SpreadMethod);
        _interp.variables.set("Sprite", Sprite);
        _interp.variables.set("StageAlign", StageAlign);
        _interp.variables.set("StageDisplayState", StageDisplayState);
        _interp.variables.set("StageQuality", StageQuality);
        _interp.variables.set("StageScaleMode", StageScaleMode);
        _interp.variables.set("Tilesheet", Tilesheet);
        _interp.variables.set("Clipboard", Clipboard);
        _interp.variables.set("ClipboardTransferMode", ClipboardTransferMode);
        _interp.variables.set("AccelerometerEvent", AccelerometerEvent);
        _interp.variables.set("ActivityEvent", ActivityEvent);
        _interp.variables.set("AsyncErrorEvent", AsyncErrorEvent);
        _interp.variables.set("ContextMenuEvent", ContextMenuEvent);
        _interp.variables.set("DataEvent", DataEvent);
        _interp.variables.set("ErrorEvent", ErrorEvent);
        _interp.variables.set("Event", Event);
        _interp.variables.set("EventDispatcher", EventDispatcher);
        _interp.variables.set("EventPhase", EventPhase);
        _interp.variables.set("FocusEvent", FocusEvent);
        _interp.variables.set("FullScreenEvent", FullScreenEvent);
        _interp.variables.set("GameInputEvent", GameInputEvent);
        _interp.variables.set("HTTPStatusEvent", HTTPStatusEvent);
        _interp.variables.set("IOErrorEvent", IOErrorEvent);
        _interp.variables.set("KeyboardEvent", KeyboardEvent);
        _interp.variables.set("MouseEvent", MouseEvent);
        _interp.variables.set("NetStatusEvent", NetStatusEvent);
        _interp.variables.set("ProgressEvent", ProgressEvent);
        _interp.variables.set("SampleDataEvent", SampleDataEvent);
        _interp.variables.set("SecurityErrorEvent", SecurityErrorEvent);
        _interp.variables.set("TextEvent", TextEvent);
        _interp.variables.set("TimerEvent", TimerEvent);
        _interp.variables.set("TouchEvent", TouchEvent);
        _interp.variables.set("UncaughtErrorEvent", UncaughtErrorEvent);
        _interp.variables.set("UncaughtErrorEvents", UncaughtErrorEvents);
        _interp.variables.set("ColorTransform", ColorTransform);
        _interp.variables.set("Matrix", Matrix);
        _interp.variables.set("Matrix3D", Matrix3D);
        _interp.variables.set("Orientation3D", Orientation3D);
        _interp.variables.set("PerspectiveProjection", PerspectiveProjection);
        _interp.variables.set("Point", Point);
        _interp.variables.set("Rectangle", Rectangle);
        _interp.variables.set("Transform", Transform);
        _interp.variables.set("Utils3D", Utils3D);
        _interp.variables.set("Vector3D", Vector3D);
        _interp.variables.set("Sound", Sound);
        _interp.variables.set("SoundChannel", SoundChannel);
        _interp.variables.set("SoundTransform", SoundTransform);
        _interp.variables.set("AntiAliasType", AntiAliasType);
        _interp.variables.set("Font", Font);
        _interp.variables.set("FontStyle", FontStyle);
        _interp.variables.set("FontType", FontType);
        _interp.variables.set("GridFitType", GridFitType);
        _interp.variables.set("TextField", TextField);
        _interp.variables.set("TextFieldAutoSize", TextFieldAutoSize);
        _interp.variables.set("TextFieldType", TextFieldType);
        _interp.variables.set("TextFormat", TextFormat);
        _interp.variables.set("TextFormatAlign", TextFormatAlign);
        _interp.variables.set("TextLineMetrics", TextLineMetrics);
        _interp.variables.set("GameInput", GameInput);
        _interp.variables.set("GameInputControl", GameInputControl);
        _interp.variables.set("GameInputDevice", GameInputDevice);
        _interp.variables.set("Keyboard", Keyboard);
        _interp.variables.set("Mouse", Mouse);
        _interp.variables.set("Multitouch", Multitouch);
        _interp.variables.set("MultitouchInputMode", MultitouchInputMode);
        _interp.variables.set("g", graphics);
        
        _interp.variables.set("stage", Lib.current.stage);
        _interp.variables.set("__clientWidth", Lib.current.stage.stageWidth);
        _interp.variables.set("__clientHeight", Lib.current.stage.stageHeight);
        
        _interp.variables.set("addChild", addChild);
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    private function enterFrame(e:Event):Void 
    {
        #if sys
        var time = FileSystem.stat(_file).mtime;
        
        if (DateCompare.compare(time, _lastTime) != 0)
        {
            _lastTime = time;
            
            var parsed = parseCode(Assets.getText(_file));
            
            try
            {
                if (parsed != null)
                {
                    graphics.clear();
                    removeChildren();
                    execute(parsed);
                }
            }
            catch (msg:String)
            {
                #if sys
                Sys.stderr().writeString("ERROR: " + msg);
                #else
                trace(msg);
                #end
            }
            
        }
        #end
    }
    
    public function requestCompletion():Array<String>
    {
        var results = new Array<String>();
        
        var keys = _interp.variables.keys();
        
        while (keys.hasNext())
        {
            results.push(keys.next());
        }
        
        return results;
    }
    
    public function requestVarFields(variable:String):Array<String>
    {
        return Reflect.fields(_interp.variables.get(variable));
    }
	
    public function parseCode(code:String)
    {
        try
        {
            var parsed = _parser.parseString(code);
            return parsed;
        }
        catch (msg:String)
        {
            #if sys
            Sys.stderr().writeString("ERROR: " + msg);
            #else
            trace(msg);
            #end
            
            return null;
        }
    }
    
    public function execute(ast:Expr)
    {
        _interp.execute(ast);
    }
    
}