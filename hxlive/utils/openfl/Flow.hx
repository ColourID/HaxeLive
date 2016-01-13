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
            totalHeight += d.x + d.height;
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