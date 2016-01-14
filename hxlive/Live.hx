package hxlive;

#if openfl
typedef Live = hxlive.openfl.Live;
#elseif kha
typedef Live = hxlive.kha.Live;
#end