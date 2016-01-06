package;

import hxlive.openfl.Live;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
import hxlive.DateCompare;
import hscript.Expr;

class Main extends Sprite
{

	private var live:Live;
	
	public function new()
	{
		super();
		
		live = new Live("info/script.hs");
        
        addChild(live);
	}
    
    

}
