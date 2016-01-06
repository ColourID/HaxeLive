package hxlive;
import hscript.Interp;

class Exporter
{

    public static function exportToHaxeFile(script:String, file:String, interp:Interp, eol:String = "\r\n")
    {
        var className = ~/\/\/class ([\w_0-9]+)$/;
        var functionName = ~/function ([\w_0-9]+)/;
        var variable = ~/([\w_0-9]+) = [^;]+?;/;
        var decl = ~/new ([\w_0-9]+)/;
        
        var imports = new Array<String>();
        
        var results = "";
        
        if (decl.match(script))
        {
            var matches = decl.split(script);
            for (i in 0...matches.length)
            {
                addImport(imports, Misc.getTypeName(matches[i]));
            }
        }
        
        results += "package;$eol";
        
        for (imp in imports)
            results += "import $imp;$eol";
        
        if (className.match(script))
        {
            var matched = className.matched(1);
            results += "$eol class $matched {";
        }
        
        
    }
    
    private static function addImport(arr:Array<String>, value:String)
    {
        for (item in arr)
        {
            if (item == value)
                return;
        }
        arr.push(value);
    }
    
}