package hxlive.utils.openfl;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.Lib;

class Alignment
{

    public static function alignLeft(obj:DisplayObject, padding:Float = 2)
    {
        obj.x = padding;
    }
    
    public static function alignRight(obj:DisplayObject, padding:Float = 2)
    {
        obj.x = obj.parent.width - obj.width - padding;
    }
    
    public static function alignTop(obj:DisplayObject, padding:Float = 2)
    {
        obj.y = padding;
    }
    
    public static function alignBottom(obj:DisplayObject, padding:Float = 2)
    {
        obj.y = obj.parent.height - obj.height - padding;
    }
    
    public static function alignCenter(obj:DisplayObject)
    {
        centerHorizontally(obj);
        centerVertically(obj);
    }
    
    public static function centerVertically(obj:DisplayObject)
    {
        obj.y = obj.parent.height / 2 - obj.height / 2;
    }
    
    public static function centerHorizontally(obj:DisplayObject)
    {
        obj.x = obj.parent.width / 2 - obj.width / 2;
    }
    
}