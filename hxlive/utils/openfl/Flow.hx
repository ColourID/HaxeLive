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
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

class Flow
{

    public static function flowFromTop(obj:DisplayObjectContainer, padding:Float = 2)
    {
        var totalHeight:Float = 0;
        for (i in 0...obj.numChildren)
        {
            var d:DisplayObject = obj.getChildAt(i);
            if (i == 0)
                d.y = padding;
            else
                d.y += totalHeight + padding;
            
            d.x = padding;
            totalHeight += d.y + d.height;
        }
    }
    
    public static function flowFromLeft(obj:DisplayObjectContainer, padding:Float = 2)
    {
        var totalWidth:Float = 0;
        
        for (i in 0...obj.numChildren)
        {
            var d:DisplayObject = obj.getChildAt(i);
            if (i == 0)
                d.x = padding;
            else
                d.x += totalWidth + padding;
            
            d.y = padding;
            
            totalWidth += d.x + d.width;
        }
    }
    
}