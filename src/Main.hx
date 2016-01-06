package;

import hxlive.openfl.Live;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
import hxlive.DateCompare;
import hscript.Expr;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class Main extends Sprite
{

	private var live:Live;
    private var _lastTime:Date;
	
	public function new()
	{
		super();
		
		live = new Live(["addChild", addChild]);
        _lastTime = Date.now();
        
        addEventListener(Event.ENTER_FRAME, enterFrame);
	}
    
    private function enterFrame(e:Event):Void 
    {
        #if sys
        var time = FileSystem.stat("info/script.hs").mtime;
        
        if (DateCompare.compare(time, _lastTime) != 0)
        {
            var parsed:Expr = live.parseCode("info/script.hs");
            removeChildren();
            live.execute(parsed);
        }
        #end
    }

}
