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

package hxlive;

class DateCompare
{

	public static function compare(d1:Date, d2:Date)
	{
		var d1Result = d1.getSeconds() + d1.getMinutes() * 60 + d1.getHours() * 3600;
		var d2Result = d2.getSeconds() + d2.getMinutes() * 60 + d2.getHours() * 3600;
        
		if (d1Result > d2Result)
			return 1;
		else if (d1Result < d2Result)
			return -1;
		else
			return 0;
	}
	
}
