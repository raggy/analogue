package analogue;
import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;
import haxe.ds.ObjectMap;
import msignal.Signal;

class Entity implements Hashable
{
	public var added(default, null):Signal2<Entity, Dynamic>;
	public var components(default, null):ObjectMap<Class<Dynamic>, Dynamic>;
	public var key:Int;
	public var removed(default, null):Signal2<Entity, Dynamic>;
		
	public function new()
	{
		added = new Signal2();
		components = new ObjectMap<Class<Dynamic>, Dynamic>();
		key = HashKey.next();
		removed = new Signal2();
	}
	
	/**
	 * Add a component to this Entity
	 * @param	component
	 */
	public inline function add(component:Dynamic):Void
	{
		var type = Type.getClass(component);

		if (has(type))
		{
			throw "Component of type " + type + " already exists within this Entity.";
		}
		else
		{
			components.set(type, component);
		}
			
		added.dispatch(this, component);
	}
	
	/**
	 * Get whether Entity has component of type
	 * @return true if Entity has component of type
	 */
	public inline function has(type:Class<Dynamic>):Bool
	{
		return components.exists(type);
	}
	
	/**
	 * Get component with type T
	 * @param   type    Type of component to get
	 * @return	        Component of type T
	 */
	public inline function get<T>(type:Class<T>):T
	{
		if (has(type))
		{
			return components.get(type);
		}
		else
		{
			throw "Entity does not have component of type " + type + ".";
		}
	}
		
	/**
	 * Remove a component from this Entity
	 * @param	type
	 */
	public inline function remove(type:Dynamic):Void 
	{
		if (has(type))
		{
			removed.dispatch(this, components.get(type));
			components.remove(type);
		}
		else
		{
			throw "Entity does not have component of type " + type + ".";
		}
	}
	
	/**
	 * @private
	 */
	public inline function toString():String
	{
		return "[Entity key=" + key + "]";
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