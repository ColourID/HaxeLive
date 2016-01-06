function createText(text)
{
    txt = new TextField();
    txt.defaultTextFormat = new TextFormat(Assets.getFont("font/OpenSans-Regular.ttf"), 11, 0);
    txt.embedFonts = true;
    txt.selectable = false;
    txt.text = text;
    
    return txt;
}

myText = createText("This is some text");
myText.x = 5;
myText.y = 5;

addChild(myText);