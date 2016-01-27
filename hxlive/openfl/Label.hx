package hxlive.openfl;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.Assets;

class Label extends TextField
{

    public function new(value:String, fontFile:String, size:Int, color:hxlive.utils.Color)
    {
        super();
        
        defaultTextFormat = new TextFormat(Assets.getFont(fontFile).fontName, size, color.value);
        autoSize = TextFieldAutoSize.LEFT;
        embedFonts = true;
        selectable = false;
        multiline = false;
        wordWrap = false;
        text = value;
    }
    
}