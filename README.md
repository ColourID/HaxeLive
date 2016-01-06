# HaxeLive
HaxeLive is a library that currently supports OpenFL in bringing live preview capabilities.

## Using this library
This library currently uses HScript to parse code and execute the results.

In Main.hx, we have the following code to help us with the live preview capabilities:
    
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

Just make sure that when the code is parsed successfully, that you clear all the visual UI before then executing the parsed results.

## Editing your script file
You can use any program or code editor of your choice to edit the script file. You will need to place into your assets folder the following file: `info/script.hs`.

This is the file that the code above looks at, but you can place and name it as you please.

The Live class also provides two functions for getting the input/output streams of the application, so you can use this for completion.

The completion functions are designed to aid simply aid in code editing, so you can extend your editor, or create your own. There will be a small editor in this repo (written in C#) for those on Windows for your convenience.

## Submitting a Pull Request
You can submit a pull request for one of these reasons:
    
 1. To submit a patch for a bug fix or improvement.
 2. To submit a feature for a different backend, such as HaxeFlixel.

For improvements, this must improve only the functionality of the Live class, as changes in API will need to be modified in all other backends to match.

When creating a backend, match the API as seen in the current backend for `openfl`. This will make it easier for users to use a different backend without needing to modify too much of their codebase.

All pull requests should be licensed under MIT for convenience.