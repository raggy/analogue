package analogue.core;
import hsl.haxe.Signaler;

interface ISystems
{
	var created(default, null):Signaler<ISystem>;
	var removed(default, null):Signaler<ISystem>;
	function create(type:Class<ISystem>):ISystem;
	function get<T:ISystem>(type:Class<T>):T;
	function remove(type:Class<ISystem>):ISystem;
	function destroy():Void;
}
