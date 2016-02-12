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

class Location
{

    public static function setLocationLeftOf(obj:Window, of:Window, padding:Int = 2)
    {
        var objSize = obj.getSize();
        var ofPos = of.getPosition();
        var ofSize = of.getSize();
        
        obj.move(cast (ofPos.x - objSize.width - padding), cast (((ofSize.height - objSize.height) / 2) + ofPos.y));
    }
    
    public static function setLocationTopOf(obj:Window, of:Window, padding:Int = 2)
    {
        var objSize = obj.getSize();
        var ofPos = of.getPosition();
        var ofSize = of.getSize();
        
        obj.move(cast (((ofSize.width - objSize.width) / 2) + ofPos.x), cast (ofPos.y - objSize.height - padding));
    }
    
    public static function setLocationRightOf(obj:Window, of:Window, padding:Int = 2)
    {
        var objSize = obj.getSize();
        var ofPos = of.getPosition();
        var ofSize = of.getSize();
        
        obj.move(cast (ofPos.x + ofSize.width + padding), cast (((ofSize.height - objSize.height) / 2) + ofPos.y));
    }
    
    public static function setLocationBottomOf(obj:Window, of:Window, padding:Int = 2)
    {
        var objSize = obj.getSize();
        var ofPos = of.getPosition();
        var ofSize = of.getSize();
        
        obj.move(cast (((ofSize.width - objSize.width) / 2) + ofPos.x), cast (ofPos.y + ofSize.height + padding));
    }
    
}