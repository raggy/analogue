package analogue.core;

interface INodes
{
	function destroy():Void;
	function get<T>(type:Class<T>):List<T>;
	function register<T>(type:T):Void;
	function deregister<T>(type:T):Void;
	function create(entity:IEntity):Void;
	function clean(entity:IEntity):Void;
	function remove(entity:IEntity):Void;
}