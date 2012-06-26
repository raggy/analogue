package com.hairychestedgames.analogue.base;
import com.hairychestedgames.analogue.core.IEntity;
import com.hairychestedgames.analogue.core.INode;

/**
 * Base class for a node
 * @author Benjamin Davis
 */
class Node implements INode, implements haxe.rtti.Infos
{
		
	public var entity(default, null):IEntity;
	
	public function new(entity:IEntity)
	{
		this.entity = entity;
	}
}