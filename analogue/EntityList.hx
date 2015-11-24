package analogue;

import msignal.Signal;

interface EntityList
{
	var added(default, null):Signal1<Entity>;
	var changed(default, null):Signal1<Entity>;
	var removed(default, null):Signal1<Entity>;

	function free():Void;
	function iterator():Iterator<Entity>;
}
