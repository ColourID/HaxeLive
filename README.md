[![Build Status](https://travis-ci.org/ColourID/HaxeLive.svg?branch=master)](https://travis-ci.org/ColourID/HaxeLive)

# HaxeLive
HaxeLive is a library that currently supports OpenFL in bringing live preview capabilities.

**Note** `SimpleButton`'s in OpenFL does not function correctly as implemented in our code. We are working on whether or not this is an OpenFL issue or specific to the codebase and find a solution. For now, the code works in version 3.4, so if you need SimpleButton's to function properly, that's the version we recommend to use.

## Using this library
This library parses JSON-formatted files into generated scenes that can be live-previewed for fast prototyping, as well as redistributed and reused for your projects.

In Main.hx, we have the following code to help us with the live preview capabilities:
    
    import hxlive.Live;
    import openfl.display.Sprite;

    class Main extends Sprite
    {

        private var live:Live;
        
        public function new()
        {
            super();
            
            live = new Live("info/config.json");
            
            addChild(live);
        }

    }

`config.json` is required to make configuration settings with HaxeLive. This is now required, as it will help to provide a more robust way of switching between scenes without needing to recompile your application to test them. The configuration file is only used with the `Live` class. Nothing has changed with `SceneGen` so your codebase should remain the same in that regard.

An example of the configuration file may look something like this:
    
    {
        
        "file": "info/MyBase.json"
        
    }

All of the parsing, scene generation and previewing is done automatically.

Once you have designed an interface you like, you can use the `SceneGen` class, followed by the `generate` function that takes the parsed data from a JSON file.

## Exporting
You can now export what you see on the screen into usable Haxe source code to use in your projects.

To do this, simply press CTRL+E on any C++ target and a dialog will appear allowing you to select a location you wish to save your Haxe code to. Once you have chosen a location and hit save, the user interface will be exported to Haxe code.

Why Export? Exporting your JSON file into usable Haxe code will make it easier for you to add logic to the scenes you create, instead of using the `SceneGen` class. It also removes the tedious task of setting up all of these objects yourself.

## Documentation
Because there is a lot of information regarding this library, please consult the [wiki](https://github.com/ColourID/HaxeLive/wiki).

## Submitting a Pull Request
You can submit a pull request for one of these reasons:
    
 1. To submit a patch for a bug fix or improvement.
 2. To submit a feature for a different backend.

For improvements, this must improve only the functionality of the Live class, as changes in API will need to be modified in all other backends to match.

When creating a backend, match the API as seen in the current backend for `openfl`. This will make it easier for users to use a different backend without needing to modify too much of their codebase.

All pull requests should be licensed under MIT for convenience.
