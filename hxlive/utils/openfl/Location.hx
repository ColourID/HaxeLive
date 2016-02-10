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

package hxlive.utils.openfl;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.Lib;

class Location
{

    public static function setLocationLeftOf(obj:DisplayObject, of:DisplayObject, padding:Float = 2)
    {
        obj.x = of.x - obj.width - padding;
        obj.y = (of.height / 2 - obj.height / 2) + of.y;
    }
    
    public static function setLocationTopOf(obj:DisplayObject, of:DisplayObject, padding:Float = 2)
    {
        obj.y = of.y - obj.height - padding;
        obj.x = (of.width / 2 - obj.width / 2) + of.x;
    }
    
    public static function setLocationRightOf(obj:DisplayObject, of:DisplayObject, padding:Float = 2)
    {
        obj.x = of.x + of.width + padding;
        obj.y = (of.height / 2 - obj.height / 2) + of.y;
    }
    
    public static function setLocationBottomOf(obj:DisplayObject, of:DisplayObject, padding:Float = 2)
    {
        obj.x = (of.width / 2 - obj.width / 2) + of.x;
        obj.y = of.y + of.height + padding;
    }
    
    public static inline function screenFromTop(obj:DisplayObject, offset:Float = 0)
	{
        obj.x = Lib.current.stage.stageWidth / 2 - obj.width / 2;
        obj.y = offset;
	}
    
    public static inline function screenFromLeft(obj:DisplayObject, offset:Float = 0)
    {
        obj.x = offset;
        obj.y = Lib.current.stage.stageHeight / 2 - obj.height / 2;
    }
    
    public static inline function screenFromRight(obj:DisplayObject, offset:Float = 0)
    {
        obj.x = Lib.current.stage.stageWidth - obj.width + offset;
        obj.y = Lib.current.stage.stageHeight / 2 - obj.height / 2;
    }
    
    public static inline function screenFromBottom(obj:DisplayObject, offset:Float = 0)
    {
        obj.y = Lib.current.stage.stageHeight - obj.height + offset;
        obj.x = Lib.current.stage.stageWidth / 2 - obj.width / 2;
    }
    
}