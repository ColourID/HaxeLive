/*
The MIT License (MIT)

Copyright (c) 2015 tienery and other contributors.

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

class Color
{
	
	/**
	 * Returns the color with the alpha channel (alpha, red, green, blue).
	 */
	public var valueWithAlpha:UInt;
	
	/**
	 * Returns only the alpha value extracted from `valueWithAlpha` as a `Float` percentage from 0-1.
	 */
	public var alpha(get, never):Float;
	function get_alpha()
	{
		return (((valueWithAlpha >> 24) & 0xFF) / 255);
	}
	
	/**
	 * Returns the color without the alpha channel (red, green, blue)
	 */
	public var value:Int;
	
	/**
	 * Creates a `Color` type with the given values.
	 * @param	red		The `red` channel identifying a range from 0-255, or a hexadecimal value up to 0xFF.
	 * @param	green	The `green` channel identifying a range from 0-255, or a hexadecimal value up to 0xFF.
	 * @param	blue	The `blue` channel identifying a range from 0-255, or a hexadecimal value up to 0xFF.
	 * @param	alpha	The `alpha` channel identifying a range from 0-255, or a hexadecimal value up to 0xFF.
	 */
	public function new(red:Int = 0x00, green:Int = 0x00, blue:Int = 0x00, alpha:Int = 0xFF) 
	{
		valueWithAlpha = ((alpha << 24) | (red << 16) | (green << 8) | (blue << 0)) & 0xFFFFFFFF;
		value = ((red << 16) | (green << 8) | (blue << 0)) & 0xFFFFFF;
	}
	
	/**
	 * Converts the hexadecimal equivalent from a string as a `Color`.
	 * @param	hex		The string value that represents a hexadecimal value. If the alpha value is excluded, the
	 * 					generated alpha value defaults to 0xFF, else the included value is extracted from the given
	 * 					`hex` appropriately.
	 * @return	Returns a `Color` type representing the given `hex` value.
	 */
	public static inline function colorFromHex(hex:String):Color
	{
		var value = Std.parseInt(hex);
		var col = new Color();
		if (value > 0xFFFFFF)
		{
			col.valueWithAlpha = value;
			col.value = (value >> 24) & 0xFFFFFF;
		}
		else 
		{
			col.value = value;
			col.valueWithAlpha = ((0xFF << 24) | value) & 0xFFFFFFFF;
		}
		
		return col;
	}
	
	/**
	 * Gets a color by a known name.
	 * @param	name	The name of the color. This must be the same as any one of the function names listed
	 * 					as static functions. Names are case-sensitive.
	 * @return	Returns a `Color` type with its respective values.
	 */
	public static inline function colorByName(name:String):Color
	{
		var fn:Dynamic = Reflect.field(Color, name);
		var result = Reflect.callMethod(Color, fn, []);
		if (result == null)
		{
			trace("The name of the field " + name + " did not exist.");
			return null;
		}
		else
		{
			if (Std.is(result, Color))
				return result;
			else
				return null;
		}
	}
	
	//Colors taken from MSDN: https://msdn.microsoft.com/en-us/library/system.drawing.color%28v=vs.110%29.aspx
	
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF0F8FF.
	 */
	public static inline function aliceBlue() return new Color(0xF0, 0xF8, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFAEBD7.
	 */
	public static inline function antiqueWhite() return new Color(0xFA, 0xEB, 0xD7);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00FFFF.
	 */
	public static inline function aqua() return new Color(0x00, 0xFF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x7FFFD4.
	 */
	public static inline function aquamarine() return new Color(0x7F, 0xFF, 0xD4);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF0FFFF.
	 */
	public static inline function azure() return new Color(0xF0, 0xFF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF5F5DC.
	 */
	public static inline function beige() return new Color(0xF5, 0xF5, 0xDC);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFE4C4.
	 */
	public static inline function bisque() return new Color(0xFF, 0xE4, 0xC4);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x000000.
	 */
	public static inline function black() return new Color(0x00, 0x00, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFEBCD.
	 */
	public static inline function blanchedAlmond() return new Color(0xFF, 0xEB, 0xCD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x0000FF.
	 */
	public static inline function blue() return new Color(0x00, 0x00, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x8A2BE2.
	 */
	public static inline function blueViolet() return new Color(0x8A, 0x2B, 0xE2);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xA52A2A.
	 */
	public static inline function brown() return new Color(0xA5, 0x2A, 0x2A);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDEB887.
	 */
	public static inline function burlyWood() return new Color(0xDE, 0xB8, 0x87);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x5F9EA0.
	 */
	public static inline function cadetBlue() return new Color(0x5F, 0x9E, 0xA0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x7FFF00.
	 */
	public static inline function chartreuse() return new Color(0x7F, 0xFF, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xD2691E.
	 */
	public static inline function chocolate() return new Color(0xD2, 0x69, 0x1E);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF7F50.
	 */
	public static inline function coral() return new Color(0xFF, 0x7F, 0x50);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x6495ED.
	 */
	public static inline function cornflowerBlue() return new Color(0x64, 0x95, 0xED);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFF8DC.
	 */
	public static inline function cornsilk() return new Color(0xFF, 0xF8, 0xDC);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDC143C.
	 */
	public static inline function crimson() return new Color(0xDC, 0x14, 0x3C);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00FFFF.
	 */
	public static inline function cyan() return new Color(0x00, 0xFF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00008B.
	 */
	public static inline function darkBlue() return new Color(0x00, 0x00, 0x8B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x008B8B.
	 */
	public static inline function darkCyan() return new Color(0x00, 0x8B, 0x8B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xB8860B.
	 */
	public static inline function darkGoldrenrod() return new Color(0xB8, 0x86, 0x0B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xA9A9A9.
	 */
	public static inline function darkGray() return new Color(0xA9, 0xA9, 0xA9);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x006400.
	 */
	public static inline function darkGreen() return new Color(0x00, 0x64, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xBDB76B.
	 */
	public static inline function darkKhaki() return new Color(0xBD, 0xB7, 0x6B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x8B008B.
	 */
	public static inline function darkMagenta() return new Color(0x8B, 0x00, 0x8B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x556B2F.
	 */
	public static inline function darkOliveGreen() return new Color(0x55, 0x6B, 0x2F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF8C00.
	 */
	public static inline function darkOrange() return new Color(0xFF, 0x8C, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x9932CC.
	 */
	public static inline function darkOrchid() return new Color(0x99, 0x32, 0xCC);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x8B0000.
	 */
	public static inline function darkRed() return new Color(0x8B, 0x00, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xE9967A.
	 */
	public static inline function darkSalmon() return new Color(0xE9, 0x96, 0x7A);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x8FBC8F.
	 */
	public static inline function darkSeaGreen() return new Color(0x8F, 0xBC, 0x8F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x483D8B.
	 */
	public static inline function darkSlateBlue() return new Color(0x48, 0x3D, 0x8B);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x2F4F4F.
	 */
	public static inline function darkSlateGray() return new Color(0x2F, 0x4F, 0x4F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00CED1.
	 */
	public static inline function darkTurquoise() return new Color(0x00, 0xCE, 0xD1);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x9400D3.
	 */
	public static inline function darkViolet() return new Color(0x94, 0x00, 0xD3);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF1493.
	 */
	public static inline function deepPink() return new Color(0xFF, 0x14, 0x93);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00BFFF.
	 */
	public static inline function deepSkyBlue() return new Color(0x00, 0xBF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x696969.
	 */
	public static inline function dimGray() return new Color(0x69, 0x69, 0x69);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x1E90FF.
	 */
	public static inline function dodgerBlue() return new Color(0x1E, 0x90, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xB22222.
	 */
	public static inline function firebrick() return new Color(0xB2, 0x22, 0x22);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFAF0.
	 */
	public static inline function floralWhite() return new Color(0xFF, 0xFA, 0xF0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x228B22.
	 */
	public static inline function forestGreen() return new Color(0x22, 0x8B, 0x22);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF00FF.
	 */
	public static inline function fuchsia() return new Color(0xFF, 0x00, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDCDCDC.
	 */
	public static inline function gainsboro() return new Color(0xDC, 0xDC, 0xDC);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF8F8FF.
	 */
	public static inline function ghostWhite() return new Color(0xF8, 0xF8, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFD700.
	 */
	public static inline function gold() return new Color(0xFF, 0xD7, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDAA520.
	 */
	public static inline function goldenrod() return new Color(0xDA, 0xA5, 0x20);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x808080.
	 */
	public static inline function gray() return new Color(0x80, 0x80, 0x80);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x008000.
	 */
	public static inline function green() return new Color(0x00, 0x80, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xADFF2F.
	 */
	public static inline function greenYellow() return new Color(0xAD, 0xFF, 0x2F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF0FFF0.
	 */
	public static inline function honeydew() return new Color(0xF0, 0xFF, 0xF0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF69B4.
	 */
	public static inline function hotPink() return new Color(0xFF, 0x69, 0xB4);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xCD5C5C.
	 */
	public static inline function indianRed() return new Color(0xCD, 0x5C, 0x5C);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x4B0082.
	 */
	public static inline function indigo() return new Color(0x4B, 0x00, 0x82);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFFF0.
	 */
	public static inline function ivory() return new Color(0xFF, 0xFF, 0xF0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF0E68C.
	 */
	public static inline function khaki() return new Color(0xF0, 0xE6, 0x8C);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xE6E6FA.
	 */
	public static inline function lavender() return new Color(0xE6, 0xE6, 0xFA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFF0F5.
	 */
	public static inline function lavenderBlush() return new Color(0xFF, 0xF0, 0xF5);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x7CFC00.
	 */
	public static inline function lawnGreen() return new Color(0x7C, 0xFC, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFACD.
	 */
	public static inline function lemonChiffon() return new Color(0xFF, 0xFA, 0xCD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xADD8E6.
	 */
	public static inline function lightBlue() return new Color(0xAD, 0xD8, 0xE6);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF08080.
	 */
	public static inline function lightCoral() return new Color(0xF0, 0x80, 0x80);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xE0FFFF.
	 */
	public static inline function lightCyan() return new Color(0xE0, 0xFF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFAFAD2.
	 */
	public static inline function lightGoldenrodYellow() return new Color(0xFA, 0xFA, 0xD2);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xD3D3D3.
	 */
	public static inline function lightGray() return new Color(0xD3, 0xD3, 0xD3);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x90EE90.
	 */
	public static inline function lightGreen() return new Color(0x90, 0xEE, 0x90);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFB6C1.
	 */
	public static inline function lightPink() return new Color(0xFF, 0xB6, 0xC1);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFA07A.
	 */
	public static inline function lightSalmon() return new Color(0xFF, 0xA0, 0x7A);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x20B2AA.
	 */
	public static inline function lightSeaGreen() return new Color(0x20, 0xB2, 0xAA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x87CEFA.
	 */
	public static inline function lightSkyBlue() return new Color(0x87, 0xCE, 0xFA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x778899.
	 */
	public static inline function lightSlateGray() return new Color(0x77, 0x88, 0x99);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xB0C4DE.
	 */
	public static inline function lightSteelBlue() return new Color(0xB0, 0xC4, 0xDE);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFFE0.
	 */
	public static inline function lightYellow() return new Color(0xFF, 0xFF, 0xE0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00FF00.
	 */
	public static inline function lime() return new Color(0x00, 0xFF, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x32CD32.
	 */
	public static inline function limeGreen() return new Color(0x32, 0xCD, 0x32);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFAF0E6.
	 */
	public static inline function linen() return new Color(0xFA, 0xF0, 0xE6);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF00FF.
	 */
	public static inline function magenta() return new Color(0xFF, 0x00, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x800000.
	 */
	public static inline function maroon() return new Color(0x80, 0x00, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x66CDAA.
	 */
	public static inline function mediumAquamarine() return new Color(0x66, 0xCD, 0xAA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x0000CD.
	 */
	public static inline function mediumBlue() return new Color(0x00, 0x00, 0xCD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xBA55D3.
	 */
	public static inline function mediumOrchid() return new Color(0xBA, 0x55, 0xD3);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x9370DB.
	 */
	public static inline function mediumPurple() return new Color(0x93, 0x70, 0xDB);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x3CB371.
	 */
	public static inline function mediumSeaGreen() return new Color(0x3C, 0xB3, 0x71);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x7B68EE.
	 */
	public static inline function mediumSlateBlue() return new Color(0x7B, 0x68, 0xEE);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00FA9A.
	 */
	public static inline function mediumSpringGreen() return new Color(0x00, 0xFA, 0x9A);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x48D1CC.
	 */
	public static inline function mediumTurquoise() return new Color(0x48, 0xD1, 0xCC);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xC71585.
	 */
	public static inline function mediumVioletRed() return new Color(0xC7, 0x15, 0x85);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x191970.
	 */
	public static inline function midnightBlue() return new Color(0x19, 0x19, 0x70);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF5FFFA.
	 */
	public static inline function mintCream() return new Color(0xF5, 0xFF, 0xFA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF34E1.
	 */
	public static inline function mistyRose() return new Color(0xFF, 0xE4, 0xE1);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFE4B5.
	 */
	public static inline function moccasin() return new Color(0xFF, 0xE4, 0xB5);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFDEAD.
	 */
	public static inline function navajoWhite() return new Color(0xFF, 0xDE, 0xAD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x000080.
	 */
	public static inline function navy() return new Color(0x00, 0x00, 0x80);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFDF5E6.
	 */
	public static inline function oldLace() return new Color(0xFD, 0xF5, 0xE6);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x808000.
	 */
	public static inline function olive() return new Color(0x80, 0x80, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x6B8E23.
	 */
	public static inline function oliveDrab() return new Color(0x6B, 0x8E, 0x23);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFA500.
	 */
	public static inline function orange() return new Color(0xFF, 0xA5, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF4500.
	 */
	public static inline function orangeRed() return new Color(0xFF, 0x45, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDA70D6.
	 */
	public static inline function orchid() return new Color(0xDA, 0x70, 0xD6);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xEEE8AA.
	 */
	public static inline function paleGoldenrod() return new Color(0xEE, 0xE8, 0xAA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x98FB98.
	 */
	public static inline function paleGreen() return new Color(0x98, 0xFB, 0x98);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xAFEEEE.
	 */
	public static inline function paleTurquoise() return new Color(0xAF, 0xEE, 0xEE);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDB7093.
	 */
	public static inline function paleVioletRed() return new Color(0xDB, 0x70, 0x93);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFEFD5.
	 */
	public static inline function papayaWhip() return new Color(0xFF, 0xEF, 0xD5);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFDAB9.
	 */
	public static inline function peachPuff() return new Color(0xFF, 0xDA, 0xB9);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xCD853F.
	 */
	public static inline function peru() return new Color(0xCD, 0x85, 0x3F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFC0CB.
	 */
	public static inline function pink() return new Color(0xFF, 0xC0, 0xCB);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xDDA0DD.
	 */
	public static inline function plum() return new Color(0xDD, 0xA0, 0xDD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xB0E0E6.
	 */
	public static inline function powderBlue() return new Color(0xB0, 0xE0, 0xE6);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x800080.
	 */
	public static inline function purple() return new Color(0x80, 0x00, 0x80);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF0000.
	 */
	public static inline function red() return new Color(0xFF, 0x00, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xBC8F8F.
	 */
	public static inline function rosyBrown() return new Color(0xBC, 0x8F, 0x8F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x4169E1.
	 */
	public static inline function royalBlue() return new Color(0x41, 0x69, 0xE1);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x8B4513.
	 */
	public static inline function saddleBrown() return new Color(0x8B, 0x45, 0x13);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFA8072.
	 */
	public static inline function salmon() return new Color(0xFA, 0x80, 0x72);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF4A460.
	 */
	public static inline function sandyBrown() return new Color(0xF4, 0xA4, 0x60);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x2E8B57.
	 */
	public static inline function seaGreen() return new Color(0x2E, 0x8B, 0x57);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFF5EE.
	 */
	public static inline function seaShell() return new Color(0xFF, 0xF5, 0xEE);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xA0522D.
	 */
	public static inline function sienna() return new Color(0xA0, 0x52, 0x2D);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xC0C0C0.
	 */
	public static inline function silver() return new Color(0xC0, 0xC0, 0xC0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x87CEEB.
	 */
	public static inline function skyBlue() return new Color(0x87, 0xCE, 0xEB);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x6A5ACD.
	 */
	public static inline function slateBlue() return new Color(0x6A, 0x5A, 0xCD);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x708090.
	 */
	public static inline function slateGray() return new Color(0x70, 0x80, 0x90);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFAFA.
	 */
	public static inline function snow() return new Color(0xFF, 0xFA, 0xFA);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x00FF7F.
	 */
	public static inline function springGreen() return new Color(0x00, 0xFF, 0x7F);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x4682B4.
	 */
	public static inline function steelBlue() return new Color(0x46, 0x82, 0xB4);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xD2B48C.
	 */
	public static inline function tan() return new Color(0xD2, 0xB4, 0x8C);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x008080.
	 */
	public static inline function teal() return new Color(0x00, 0x80, 0x80);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xD8BFD8.
	 */
	public static inline function thistle() return new Color(0xD8, 0xBF, 0xD8);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFF6347.
	 */
	public static inline function tomato() return new Color(0xFF, 0x63, 0x47);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x40E0D0.
	 */
	public static inline function turquoise() return new Color(0x40, 0xE0, 0xD0);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xEE82EE.
	 */
	public static inline function violet() return new Color(0xEE, 0x82, 0xEE);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF5DEB3.
	 */
	public static inline function wheat() return new Color(0xF5, 0xDE, 0xB3);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFFFF.
	 */
	public static inline function white() return new Color(0xFF, 0xFF, 0xFF);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xF5F5F5.
	 */
	public static inline function whiteSmoke() return new Color(0xF5, 0xF5, 0xF5);
	/**
	 * Returns a `Color` with the hexadecimal value of 0xFFFF00.
	 */
	public static inline function yellow() return new Color(0xFF, 0xFF, 0x00);
	/**
	 * Returns a `Color` with the hexadecimal value of 0x9ACD32.
	 */
	public static inline function yellowGreen() return new Color(0x9A, 0xCD, 0x32);
	
}