package analogue.core;
import hsl.haxe.Signaler;

interface IEntity 
{
	var components(default, null):Hash<Dynamic>;
	var nodes(default, null):Hash<INode>;
	var added(default, null):Signaler<Dynamic>;
	var removed(default, null):Signaler<Dynamic>;
	/**
	 * Add a component to this Entity
	 * @param	component
	 */
	function add(component:Dynamic):Void;
	/**
	 * Remove a component from this Entity
	 * @param	type
	 */
	function remove(type:Dynamic):Void; 
	/**
	 * Remove all components and nodes
	 */
	function destroy():Void;
}
