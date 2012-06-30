package com.hairychestedgames.analogue.base;
import com.hairychestedgames.analogue.core.IEntity;
import com.hairychestedgames.analogue.core.INode;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class Entity implements IEntity
{	
	public var components(default, null):Hash<Dynamic>;
	public var nodes(default, null):Hash<INode>;
	public var added(default, null):Signaler<Dynamic>;
	public var removed(default, null):Signaler<Dynamic>;
		
	public function new()
	{
		components = new Hash<Dynamic>();
		nodes = new Hash<INode>();
		added = new DirectSignaler<Dynamic>(this);
		removed = new DirectSignaler<Dynamic>(this);
	}
	
	/**
	 * Add a component to this Entity
	 * @param	component
	 */
	public function add(component:Dynamic):Void
	{
		var typeName = "";

		switch (Type.typeof(component))
		{
			case ValueType.TClass(component):
				typeName = Type.getClassName(component);
			case ValueType.TEnum(component):
				typeName = Type.getEnumName(component);
			default:
		}

		if (components.exists(typeName))
		{
			throw "Component of type " + typeName + " already exists within this Entity.";
		}
		else
		{
			components.set(typeName, component);
		}
			
		added.dispatch(component);
	}
		
	/**
	 * Remove a component from this Entity
	 * @param	type
	 */
	public function remove<T:(Class<Dynamic>, Enum<Dynamic>)>(type:T):Void 
	{
		var typeName:String = Type.getClassName(type);
		if (components.exists(typeName))
		{
			removed.dispatch(components.get(typeName));
			components.remove(typeName);
		}
		else
		{
			throw "Entity does not have component of type " + typeName + ".";
		}
	}
		
	/**
	 * Remove all components and nodes
	 */
	public function destroy():Void
	{
		components = null;
		nodes = null;
	}

	/**
	 * Create an entity with a list of components
	 */
	public static function with(components:Array<Dynamic>):Entity
	{
		var entity:Entity = new Entity();

		for (component in components)
		{
			if (Std.is(component, Class))
			{
				entity.add(Type.createInstance(component, []));
			}
			else
			{
				entity.add(component);
			}
		}

		return entity;
	}

}