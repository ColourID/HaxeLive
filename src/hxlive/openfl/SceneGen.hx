package hxlive.openfl;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextFieldAutoSize;
import openfl.Assets;

import haxe.Json;

import hxlive.utils.Alignment;
import hxlive.utils.Flow;
import hxlive.utils.Location;

class SceneGen
{
    
    private static var __types:Map<String, Sprite>;
    private static var __styles:Dynamic;
    private static var __spritesheet:BitmapData;
    private static var __spritemap:Map<String, BitmapData>;

    public static function generate(data:Dynamic):Sprite
    {
        if (__types == null)
            __types = new Map<String, Sprite>();
        
        if (__spritemap == null)
            __spritemap = new Map<String, BitmapData>();
        
        return createSprite(data);
    }
    
    private static function createSprite(sp:Dynamic):Sprite
    {
        var sprite = new Sprite();

        //If the scene requires types generated from another, generate and map them.
        if (sp.requires != null)
        {
            for (i in 0...sp.requires.length)
            {
                var require:Dynamic = sp.requires[i];
                generate(Json.parse(Assets.getText(require)));
            }
        }
        
        //If using a theme, get it and add to global `__styles` to use later.
        if (sp.theme != null)
        {
            __styles = Json.parse(Assets.getText(sp.theme));
        }
        
        var items = new Array<Dynamic>();
        
        if (sp.contents != null)
        {
            //Populate the sprite
            for (i in 0...sp.contents.length)
            {
                var item:Dynamic = sp.contents[i];
                items.push(item);
                
                var obj:DisplayObject = null;
                
                var style:Dynamic = null;
                
                if (item.styleName != null)
                {
                    style = Reflect.field(__styles, item.styleName);
                    
                    if (style != null)
                    {
                        setupSpritesheet(style);
                    }
                }
                
                if (item.type == "SimpleButton")
                {
                    obj = createSimpleButton(item, style);
                }
                else if (item.type == "Bitmap")
                {
                    obj = createBitmap(item);
                }
                else if (item.type == "Text")
                {
                    obj = createText(item, style);
                }
                else if (item.type == "Sprite")
                {
                    obj = createSprite(item);
                }
                else
                {
                    if (__types.exists(item.type))
                        obj = __types.get(item.type);
                    else
                    {
                        trace("The type of the name '$item.type' does not exist."); 
                        continue;
                    }
                }
                
                if (item.name != null)
                        obj.name = item.name;
                    else
                        obj.name = "Object" + i;
                
                
                sprite.addChild(obj);
            }
            
            //Set the locations and sizes of each object in the sprite
            for (i in 0...sprite.numChildren)
            {
                var obj = sprite.getChildAt(i);
                
                var padding = 2;
                if (items[i].padding != null)
                    padding = items[i].padding;
                    
                if (items[i].width != null)
                    obj.width = items[i].width;
                
                if (items[i].height != null)
                    obj.height = items[i].height;
                
                if (items[i].flow != null && Std.is(obj, Sprite))
                {
                    switch (items[i].flow)
                    {
                        case 0:
                            Flow.flowFromTop(cast (obj, Sprite), padding);
                        case 1:
                            Flow.flowFromLeft(cast (obj, Sprite), padding);
                    }
                }
                else
                {
                    if (items[i].align != null)
                    {
                        if (Reflect.isObject(items[i].align))
                        {
                            var al:Dynamic = items[i].align;
                            switch (al.alignment)
                            {
                                case 0:
                                    Location.setLocationLeftOf(obj, sprite.getChildByName(al.name), al.padding);
                                case 1:
                                    Location.setLocationTopOf(obj, sprite.getChildByName(al.name), al.padding);
                                case 2:
                                    Location.setLocationRightOf(obj, sprite.getChildByName(al.name), al.padding);
                                case 3:
                                    Location.setLocationBottomOf(obj, sprite.getChildByName(al.name), al.padding);
                            }
                        }
                        else
                        {
                            switch (items[i].align)
                            {
                                case -4:
                                    Location.screenFromBottom(obj, padding);
                                case -3:
                                    Location.screenFromRight(obj, padding);
                                case -2:
                                    Location.screenFromTop(obj, padding);
                                case -1:
                                    Location.screenFromLeft(obj, padding);
                                case 0:
                                    Alignment.alignLeft(obj, padding);
                                case 1:
                                    Alignment.alignTop(obj, padding);
                                case 2:
                                    Alignment.alignRight(obj, padding);
                                case 3:
                                    Alignment.alignBottom(obj, padding);
                                case 4:
                                    Alignment.alignCenter(obj);
                                case 5:
                                    Alignment.centerVertically(obj);
                                case 6:
                                    Alignment.centerHorizontally(obj);
                            }
                        }
                    }
                }
                
                if (items[i].x != null)
                    obj.x = items[i].x;
                
                if (items[i].y != null)
                    obj.y = items[i].y;
                
            }
        }
        
        if (sp.instanceType != null)
            __types.set(sp.instanceType, sprite);
        
        return sprite;
    }
    
    private static function createSimpleButton(smb:Dynamic, style:Dynamic = null):SimpleButton
    {
        var upState:Bitmap = null;
        var overState:Bitmap = null;
        var downState:Bitmap = null;
        var hitTestState:Bitmap = null;
        
        if (style != null)
        {
            if (style.type == "basic")
            {
                upState = new Bitmap(Assets.getBitmapData(style.bmpUpStateSource));
                
                if (style.bmpOverStateSource != null)
                    overState = new Bitmap(Assets.getBitmapData(style.bmpOverStateSource));
                
                if (style.bmpDownStateSource != null)
                    downState = new Bitmap(Assets.getBitmapData(style.bmpDownStateSource));
                
                if (style.bmpHitTestStateSource != null)
                    hitTestState = new Bitmap(Assets.getBitmapData(style.bmpHitTestStateSource));
            }
            else if (style.type == "spritesheet")
            {
                upState = new Bitmap(__spritemap.get(smb.styleValue[0]));
                
                if (smb.styleValue[1] != null)
                    overState = new Bitmap(__spritemap.get(smb.styleValue[1]));
                
                if (smb.styleValue[2] != null)
                    downState = new Bitmap(__spritemap.get(smb.styleValue[2]));
                
                if (smb.styleValue[3] != null)
                    hitTestState = new Bitmap(__spritemap.get(smb.styleValue[3]));
            }
        }
        
        var button = new SimpleButton(upState, overState, downState);
        
        if (hitTestState != null)
            button.hitTestState = hitTestState;
        
        button.alpha = smb.alpha != null ? smb.alpha : 1;
        
        return button;
    }
    
    private static function createBitmap(bmp:Dynamic):Bitmap
    {
        var bitmap = new Bitmap(Assets.getBitmapData(bmp.bitmapSource));
        bitmap.alpha = bmp.alpha != null ? bmp.alpha : 1;
        return bitmap;
    }
    
    private static function createText(text:Dynamic, style:Dynamic = null):TextField
    {
        var fontFile = "";
        var fontSize:Int = 0;
        var fontColor:Int = 0;
        
        if (style != null)
        {
            fontFile = style.fontFile;
            fontSize = style.fontSize;
            fontColor = style.fontColor;
        }
        else
        {
            fontFile = text.fontFile == null ? "font/OpenSans-Regular.ttf" : text.fontFile;
            fontSize = text.fontSize == null ? 11 : text.fontSize;
            fontColor = text.fontColor == null ? 0x000000 : text.fontColor;
        }
        
        var txt = new TextField();
        txt.defaultTextFormat = new TextFormat(Assets.getFont(fontFile).fontName, fontSize, fontColor);
        txt.embedFonts = true;
        txt.selectable = text.selectable != null ? text.selectable : false;
        txt.multiline = text.multiline != null ? text.multiline : false;
        txt.wordWrap = text.wordWrap != null ? text.wordWrap : false;
        txt.alpha = text.alpha != null ? text.alpha : 1;
        txt.text = text.text != null ? text.text : "Example Text Field";
        
        switch (text.fieldType)
        {
            case 0:
                txt.type = TextFieldType.DYNAMIC;
            case 1:
                txt.type = TextFieldType.INPUT;
            default:
                txt.type = TextFieldType.DYNAMIC;
        }
        
        switch (text.autoSize)
        {
            case 0:
                txt.autoSize = TextFieldAutoSize.NONE;
            case 1:
                txt.autoSize = TextFieldAutoSize.LEFT;
            case 2:
                txt.autoSize = TextFieldAutoSize.RIGHT;
            case 3:
                txt.autoSize = TextFieldAutoSize.CENTER;
            default:
                txt.autoSize = TextFieldAutoSize.NONE;
        }
        
        return txt;
    }
    
    private static function setupSpritesheet(style:Dynamic)
    {
        if (style.type == "spritesheet")
        {
            if (__spritesheet == null)
                __spritesheet = Assets.getBitmapData(style.source);
            else
                return;
            
            var setup = Reflect.fields(style.setup);
            
            for (i in 0...setup.length)
            {
                var field:Dynamic = Reflect.field(style.setup, setup[i]);
                
                var data = new BitmapData(field.width, field.height);
                data.copyPixels(__spritesheet, new Rectangle(field.x, field.y, field.width, field.height), new Point(0, 0));
                
                __spritemap.set(setup[i], data);
            }
            
        }
    }
    
}