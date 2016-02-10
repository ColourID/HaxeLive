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

class Alignment
{

    public static function alignLeft(obj:Window, padding:Int = 2)
    {
        obj.move(padding, obj.getPosition().y);
    }
    
    public static function alignRight(obj:Window, padding:Int = 2)
    {
        obj.move(obj.getParent().getSize().width - obj.getSize().width - padding, obj.getPosition().y);
    }
    
    public static function alignTop(obj:Window, padding:Int = 2)
    {
        obj.move(obj.getPosition().x, padding);
    }
    
    public static function alignBottom(obj:Window, padding:Int = 2)
    {
        obj.move(obj.getPosition().x, obj.getParent().getSize().height - obj.getSize().height - padding);
    }
    
    public static function alignCenter(obj:Window)
    {
        centerHorizontally(obj);
        centerVertically(obj);
    }
    
    public static function centerVertically(obj:Window)
    {
        obj.move(obj.getPosition().x, cast ((obj.getParent().getSize().height - obj.getSize().height) / 2));
    }
    
    public static function centerHorizontally(obj:Window)
    {
        obj.move(cast ((obj.getParent().getSize().width - obj.getSize().width) / 2), obj.getPosition().y);
    }
    
}