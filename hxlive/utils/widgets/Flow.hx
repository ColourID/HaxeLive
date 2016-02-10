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
package hxlive.utils.widgets;
import hx.widgets.*;

class Flow
{

    public static function flowFromTop(parent:Window, padding:Int = 2)
    {
        var totalHeight = 0;
        var children = parent.getChildren();
        
        for (i in 0...children.length)
        {
            var w:Window = children[i];
            if (i == 0)
                w.move(padding, padding);
            else
                w.move(padding, totalHeight + padding);
            
            totalHeight += w.getPosition().y + w.getSize().height;
        }
    }
    
    public static function flowFromLeft(parent:Window, padding:Int = 2)
    {
        var totalWidth = 0;
        var children = parent.getChildren();
        
        for (i in 0...children.length)
        {
            var w:Window = children[i];
            if (i == 0)
                w.move(padding, padding);
            else
                w.move(totalWidth + padding, padding);
            
            totalWidth += w.getPosition().x + w.getSize().width;
        }
    }
    
}