package com.hairychestedgames.analogue.base;
import com.hairychestedgames.analogue.base.Models;
import com.hairychestedgames.analogue.core.IEntities;
import com.hairychestedgames.analogue.core.IEntity;
import com.hairychestedgames.analogue.core.IGame;
import com.hairychestedgames.analogue.core.IModels;
import com.hairychestedgames.analogue.core.INodes;
import com.hairychestedgames.analogue.core.ISystem;
import com.hairychestedgames.analogue.core.ISystems;

class Game implements IGame
{
	public var entities(default, null):IEntities;
	public var models(default, null):IModels;
	public var nodes(default, null):INodes;
	public var systems(default, null):ISystems;
	
	public function new()
	{
		entities = new Entities();
		models = new Models();
		nodes = new Nodes();
		systems = new Systems();
		
		entities.added.bind(onEntityAdded);
		entities.changed.bind(onEntityChanged);
		entities.removed.bind(onEntityRemoved);
		
		systems.created.bind(onSystemCreated);
		systems.removed.bind(onSystemRemoved);
	}
	
	private function onEntityAdded(entity:IEntity):Void
	{
		nodes.create(entity);
	}
	
	private function onEntityChanged(entity:IEntity):Void 
	{
		nodes.clean(entity);
		nodes.create(entity);
	}
	
	private function onEntityRemoved(entity:IEntity):Void
	{
		nodes.remove(entity);
	}
	
	private function onSystemCreated(system:ISystem):Void
	{
		Reflect.setField(system, "game", this);
		system.initialise();
	}
	
	private function onSystemRemoved(system:ISystem):Void
	{
		system.destroy();
		Reflect.setField(system, "game", null);
	}
}