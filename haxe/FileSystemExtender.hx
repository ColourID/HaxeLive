package haxe;
import haxe.io.Path;
import sys.FileSystem;

class FileSystemExtender
{

    public static function getRootDir(path:String)
    {
        var fileExt = ~/\.[A-Za-z0-9]+/;
        var result = Path.normalize(path);
        
        if (fileExt.match(result))
        {
            return result.substring(0, result.lastIndexOf('/'));
        }
        else
        {
            var dir = Path.removeTrailingSlashes(result);
            return dir.substring(0, dir.lastIndexOf('/'));
        }
    }
    
}