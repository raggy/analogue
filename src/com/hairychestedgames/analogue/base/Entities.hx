package com.hairychestedgames.analogue.base;
import com.hairychestedgames.analogue.core.IEntities;
import com.hairychestedgames.analogue.core.IEntity;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class Entities implements IEntities
{
	private var all:List<IEntity>;
	public var added(default, null):Signaler<IEntity>;
	public var removed(default, null):Signaler<IEntity>;
	
	public function new()
	{
		all = new List<IEntity>();
		
		added = new DirectSignaler(this);
		removed = new DirectSignaler(this);
	}
	
	public function add(entity:IEntity):Void
	{
		all.add(entity);
		
		added.dispatch(entity);
	}
	
	public function remove(entity:IEntity):Void
	{
		removed.dispatch(entity);
		
		all.remove(entity);
	}
	
	public function iterator():Iterator<IEntity>
	{
		return all.iterator();
	}
}