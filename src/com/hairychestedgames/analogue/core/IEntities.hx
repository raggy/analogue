package com.hairychestedgames.analogue.core;
import hsl.haxe.Signaler;

interface IEntities
{
	var added(default, null):Signaler<IEntity>;
	var changed(default, null):Signaler<IEntity>;
	var removed(default, null):Signaler<IEntity>;
	var removing(default, null):Signaler<IEntity>;
	function add(entity:IEntity):IEntity;
	function remove(entity:IEntity):IEntity;
	function iterator():Iterator<IEntity>;
}
