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

package hxlive.utils;

class StringBuilder
{

    @:noCompletion private var value:String;
    
    private var _eol:String;
    public var eol(get, set):String;
    function get_eol() return _eol;
    function set_eol(val) 
    {
        if (val != "\n" || val != "\r\n")
            return _eol = "\n";
        else
            return _eol = val;
    }
    
    public function new(defaultValue:String) 
    {
        this.value = defaultValue;
    }
    
    public function appendLine(value:String)
    {
        this.value += value + eol;
    }
    
    public function appendCharLine(code:Int)
    {
        value += String.fromCharCode(code) + eol;
    }
    
    public function appendValue(value:String)
    {
        this.value += value;
    }
    
    public function appendChar(code:Int)
    {
        value += String.fromCharCode(code);
    }
    
    public function toString(?end:Int)
    {
        if (end != null)
        {
            if (end > 0)
                return value.substring(0, end + 1);
            else
                return value;
        }
        else
            return value;
    }
    
}