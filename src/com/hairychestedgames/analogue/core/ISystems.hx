package com.hairychestedgames.analogue.core;
import hsl.haxe.Signaler;

interface ISystems
{
	var created(default, null):Signaler<ISystem>;
	var removed(default, null):Signaler<ISystem>;
	function create(type:Class<ISystem>):Void;
	function get<T>(type:Class<T>):T;
	function remove(type:Class<ISystem>):Void;
	function destroy():Void;
}
