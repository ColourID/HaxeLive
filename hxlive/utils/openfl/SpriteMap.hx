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
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.Assets;
import haxe.Json;

class SpriteMap
{

    private var _spritesheet:BitmapData;
    private var _map:Map<String, BitmapData>;
    
    public function new(theme:String) 
    {
        var themeData:Dynamic = Json.parse(Assets.getText(theme));
        
        var fields = Reflect.fields(themeData);
        var source = "";
        var setup:Dynamic = null;
        
        for (field in fields)
        {
            var style:Dynamic = Reflect.field(themeData, field);
            if (style.type == "spritesheet")
            {
                setup = style.setup;
                source = style.source;
            }
        }
        
        _spritesheet = Assets.getBitmapData(source);
        
        setMap(setup);
    }
    
    public function setMap(map:Dynamic)
    {
        var fields = Reflect.fields(map);
        
        for (i in 0...fields.length)
        {
            var field:Dynamic = Reflect.field(map, fields[i]);
                
            var data = new BitmapData(field.width, field.height);
            data.copyPixels(_spritesheet, new Rectangle(field.x, field.y, field.width, field.height), new Point(0, 0));
            
            _map.set(fields[i], data);
        }
    }
    
    public function get(value:String)
    {
        return _map.get(value);
    }
    
}