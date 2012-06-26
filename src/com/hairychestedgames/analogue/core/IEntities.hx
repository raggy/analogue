package com.hairychestedgames.analogue.core;
import hsl.haxe.Signaler;

interface IEntities
{
	var added(default, null):Signaler<IEntity>;
	var removed(default, null):Signaler<IEntity>;
	function add(entity:IEntity):Void;
	function remove(entity:IEntity):Void;
	function iterator():Iterator<IEntity>;
}
