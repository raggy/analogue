package analogue.core;

interface INodes
{
	function destroy():Void;
	function get<T:INode>(type:Class<T>):List<T>;
	function create(entity:IEntity):Void;
	function clean(entity:IEntity):Void;
	function remove(entity:IEntity):Void;
}