package;

import hxlive.Live;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Lib;
import hxlive.DateCompare;

class Main extends Sprite
{

	private var live:Live;
	
	public function new()
	{
		super();
		
		live = new Live("info/MyBase.json");
        
        addChild(live);
	}
    
    

}
