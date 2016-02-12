/*

The MIT License (MIT)

Copyright (c) 2016 Colour Multimedia Enterprises

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package hxlive.widgets;
import hx.widgets.*;
import hx.widgets.Window.RepositioningGuard;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;

import hxlive.utils.widgets.Flow;
import hxlive.utils.widgets.Alignment;
import hxlive.utils.widgets.Location;

class SceneGen
{
    
    private static var __types:Map<String, Window>;
    private static var __imageLists:Map<String, ImageList>;

    public static function generate(data:Dynamic, ?parent:Window = null):Void
    {
        if (__types == null)
            __types = new Map<String, Window>();
        
        if (__imageLists == null)
            __imageLists = new Map<String, ImageList>();
        
        createWindow(data, parent);
    }
    
    private static function createWindow(data:Dynamic, ?parent:Window = null):Void
    {
        var store:Bool = false;
        
        //if parent is null, store it for later instead.
        if (parent == null)
        {
            store = true;
            parent = new Panel(null);
        }
        
        
        if (data.requires != null)
        {
            for (i in 0...data.requires.length)
            {
                var require:Dynamic = data.requires[i];
                
                generate(Json.parse(File.getContent(require)));
            }
        }
        
        new RepositioningGuard(parent);
        
        var objects = new Array<Window>();
        var items = new Array<Dynamic>();
        
        if (data.contents != null)
        {
            for (i in 0...data.contents.length)
            {
                var item:Dynamic = data.contents[i];
                
                var obj:Window = null;
                
                switch (item.type)
                {
                    case "Label": obj = createStaticText(parent, item);
                    case "Text": obj = createTextCtrl(parent, item);
                    case "StaticBox": obj = createStaticBox(parent, item);
                    case "StaticBitmap": obj = createStaticBitmap(parent, item);
                    case "Slider": obj = createSlider(parent, item);
                    case "ScrolledWindow": obj = createScrolledWindow(parent, item);
                    case "Radio": obj = createRadioButton(parent, item);
                    case "Panel": obj = createPanel(parent, item);
                    case "Notebook": obj = createNotebook(parent, item);
                    case "ImageList": createImageList(item);
                    case "Gauge": obj = createGauge(parent, item);
                    case "Checkbox": obj = createCheckbox(parent, item);
                    case "Button": obj = createButton(parent, item);
                    default:
                        if (__types.exists(item.type))
                            obj = __types.get(item.type);
                        else
                        {
                            trace('The type of the name "$item.type" does not exist.'); 
                            continue;
                        }
                }
                
                if (obj != null)
                {
                    items.push(item);
                    objects.push(obj);
                }
            }
            
            for (i in 0...objects.length)
            {
                var obj:Window = objects[i];
                var item:Dynamic = items[i];
                
                var padding = 2;
                
                if (item.padding != null)
                    padding = item.padding;
                
                var x:Int = obj.getPosition().x;
                var y:Int = obj.getPosition().y;
                var width:Int = obj.getSize().width;
                var height:Int = obj.getSize().height;
                
                if (item.width != null)
                    width = item.width;
                
                if (item.height != null)
                    height = item.height;
                
                if (item.flow != null && Std.is(obj, Panel))
                {
                    switch (item.flow)
                    {
                        case 0: Flow.flowFromTop(obj, padding);
                        case 1: Flow.flowFromLeft(obj, padding);
                    }
                }
                else if (item.align != null)
                {
                    if (Reflect.isObject(item.align))
                    {
                        var al:Dynamic = item.align;
                        switch (al.alignment)
                        {
                            case 0:
                                Location.setLocationLeftOf(obj, parent.findWindowById(al.id), al.padding);
                            case 1:
                                Location.setLocationTopOf(obj, parent.findWindowById(al.id), al.padding);
                            case 2:
                                Location.setLocationRightOf(obj, parent.findWindowById(al.id), al.padding);
                            case 3:
                                Location.setLocationBottomOf(obj, parent.findWindowById(al.id), al.padding);
                        }
                    }
                    else
                    {
                        switch (item.align)
                        {
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
                else if (data.flow != null)
                {
                    var padding = 2;
                    
                    if (data.padding != null)
                        padding = data.padding;
                    
                    switch (data.flow)
                    {
                        case 0: Flow.flowFromTop(parent, padding);
                        case 1: Flow.flowFromLeft(parent, padding);
                    }
                }
                else
                {
                    if (item.x != null)
                        x = item.x;
                    else
                        x = 0;
                    
                    if (item.y != null)
                        y = item.y;
                    else
                        y = 0;
                    
                    obj.setSize(x, y, width, height);
                }
            }
        }
        
        if (data.instanceType != null && store)
            __types.set(data.instanceType, parent);
    }
    
    private static function createStaticText(parent:Window, item:Dynamic):StaticText
    {
        var lbl = new StaticText(parent, "", item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        lbl.setLabel(item.text);
        return lbl;
    }
    
    private static function createTextCtrl(parent:Window, item:Dynamic):TextCtrl
    {
        var txt = new TextCtrl(parent, item.text, item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        return txt;
    }
    
    private static function createStaticBox(parent:Window, item:Dynamic):StaticBox
    {
        var sb = new StaticBox(parent, item.text, item.id != null ? item.id : -1);
        return sb;
    }
    
    private static function createStaticBitmap(parent:Window, item:Dynamic):StaticBitmap
    {
        if (!FileSystem.exists(item.bitmapSource) || item.bitmapSource == null)
            return null;
        
        var bmp = Bitmap.fromHaxeBytes(File.getBytes(item.bitmapSource));
        var sbmp = new StaticBitmap(parent, bmp, item.id != null ? item.id : -1);
        return sbmp;
    }
    
    private static function createSlider(parent:Window, item:Dynamic):Slider
    {
        var slider = new Slider(parent, item.value, item.min != null ? item.min : 0, item.max != null ? item.max : 100, item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        return slider;
    }
    
    private static function createScrolledWindow(parent:Window, item:Dynamic):ScrolledWindow
    {
        var scr = new ScrolledWindow(parent, item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        
        if (item.contents != null)
        {
            for (i in 0...item.contents.length)
                createWindow(item.contents[i], scr);
        }
        
        return scr;
    }
    
    private static function createRadioButton(parent:Window, item:Dynamic):RadioButton
    {
        var rdb = new RadioButton(parent, item.title, item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        if (item.checked != null)
            rdb.value = item.checked;
        else
            rdb.value = false;
        
        return rdb;
    }
    
    private static function createPanel(parent:Window, item:Dynamic):Panel
    {
        var pnl = new Panel(parent, item.style != null ? item.style : 0, item.id != null ? item.id : -1);
        
        if (item.contents != null)
            for (i in 0...item.contents.length)
                createWindow(item.contents[i], pnl);
        
        return pnl;
    }
    
    private static function createNotebook(parent:Window, item:Dynamic):Notebook
    {
        var nb = new Notebook(parent, item.id != null ? item.id : -1);
        
        var selectedIndex = item.index != null ? item.index : 0;
        
        if (item.imageListName != null)
            nb.setImageList(__imageLists.get(item.imageListName));
        
        if (item.pages != null)
        {
            for (i in 0...item.pages.length)
            {
                var page:Dynamic = item.pages[i];
                var pnl:Panel = new Panel(nb);
                
                nb.addPage(pnl, page.text != null ? page.text : "Page " + i, (selectedIndex == i), page.imageId != null ? page.imageId : -1);
                
                for (i in 0...page.contents.length)
                    createWindow(page.contents[i], pnl);
            }
        }
        
        return nb;
    }
    
    public static function createMenu(mb:MenuBar, item:Dynamic):Void
    {
        if (item.title == null)
            return;
        
        var menu:Menu = new Menu();
        
        if (item.items != null)
        {
            for (i in 0...item.items.length)
            {
                var obj:Dynamic = item.items[i];
                var menuitem = new MenuItem(menu, obj.text, obj.kind != null ? obj.kind : -1, obj.id != null ? obj.id : -1);
                
                if (obj.iconSource != null)
                    menuitem.setBitmap(Bitmap.fromHaxeBytes(File.getBytes(obj.iconSource)));
                
                menu.append(menuitem);
            }
        }
        
        mb.append(menu, item.title);
    }
    
    private static function createImageList(item:Dynamic):Void
    {
        var il = new ImageList(item.width, item.height);
        
        if (item.images != null)
        {
            for (i in 0...item.images.length)
            {
                var img:Dynamic = item.images[i];
                il.add(Bitmap.fromHaxeBytes(File.getBytes(img)));
            }
        }
        
        __imageLists.set(item.name, il);
    }
    
    private static function createGauge(parent:Window, item:Dynamic):Gauge
    {
        var pb = new Gauge(parent, item.range, item.id != null ? item.id : -1);
        
        if (item.value != null)
            pb.value = item.value;
        
        return pb;
    }
    
    private static function createCheckbox(parent:Window, item:Dynamic):CheckBox
    {
        var chb = new CheckBox(parent, item.text, item.id != null ? item.id : -1);
        
        if (item.checked != null)
            chb.value = item.checked;
        
        return chb;
    }
    
    private static function createButton(parent:Window, item:Dynamic):Button
    {
        var btn = new Button(parent, item.text, item.id != null ? item.id : -1);
        
        if (item.iconSource != null)
            btn.setBitmap(Bitmap.fromHaxeBytes(File.getBytes(item.iconSource)));
        
        return btn;
    }
    
}