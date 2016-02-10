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

package hxlive.openfl;
import openfl.display.Sprite;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import hxlive.utils.Color;
import openfl.utils.Timer;
import motion.Actuate;

class Notification extends Sprite
{

    private var _txtValue:Label;
    private var _txtCaption:Label;
    private var _currentLoc:Point;
    
    public function new(value:String, caption:String = "", padding:Float = 2, backColor:Color = null)
    {
        super();
        
        if (backColor == null)
            backColor = Color.black();
        
        alpha = 0;
        
        _txtValue = new Label(value, "font/OpenSans-Regular.ttf", 12, Color.white());
        _txtCaption = new Label(caption, "font/OpenSans-Regular.ttf", 18, Color.white());
        
        _txtCaption.x = padding;
        _txtCaption.y = padding;
        
        _txtValue.x = padding;
        
        if (_txtCaption.text != "")
        {
            _txtValue.y = _txtCaption.y + _txtCaption.height + padding;
        }
        else
            _txtValue.y = padding;
        
        var totalWidth:Float = (_txtCaption.width > _txtValue.width ? _txtCaption.width : _txtValue.width);
        
        graphics.clear();
        
        graphics.beginFill(backColor.value, 0.7);
        graphics.drawRect(0, 0, totalWidth + padding, _txtValue.y + _txtValue.height + padding);
        
        addChild(_txtCaption);
        addChild(_txtValue);
    }
    
   
    public function display(delay:Float, to:{ x:Float, y:Float })
    {
        _currentLoc = new Point(x, y);
        
        Actuate.tween(this, 1.5, { alpha: 1, x: to.x, y: to.y } );
        
        var timer = new Timer(delay, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTick);
        timer.start();
    }
    
    private function onTick(e:TimerEvent)
    {
        Actuate.tween(this, 1.5, { alpha: 0, x: _currentLoc.x, y: _currentLoc.y } );
        parent.removeChild(this);
    }
    
}

typedef Location = {
    var from: { x:Int, y:Int };
    var to: { x:Int, y:Int };
}