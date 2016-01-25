package hxlive.utils.openfl;
import openfl.display.BitmapData;
import openfl.Assets;

class SpriteMap
{

    private var _spritesheet:BitmapData;
    private var _map:Map<String, BitmapData>;
    
    public function new(source:String, map:Dynamic) 
    {
        _spritesheet = Assets.getBitmapData(source);
        
        setMap(map);
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