package hxlive;

class Misc
{
    public static function getTypeName(obj:Dynamic):String
    {
        if (Type.typeof(obj) == ValueType.TEnum)
            return Type.getEnumName(Type.getEnum(obj));
        else if (Type.typeof(obj) == ValueType.TClass)
            return Type.getClassName(Type.getClass(obj));
        else
            return "";
    }
}