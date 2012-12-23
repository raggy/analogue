package analogue;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import de.polygonal.ds.Hashable;
import de.polygonal.ds.HashKey;

class Entity implements Hashable
{
	public var added(default, null):Signaler<Dynamic>;
	public var components(default, null):Hash<Dynamic>;
	public var key:Int;
	public var removed(default, null):Signaler<Dynamic>;
		
	public function new()
	{
		added = new DirectSignaler<Dynamic>(this);
		components = new Hash<Dynamic>();
		key = HashKey.next();
		removed = new DirectSignaler<Dynamic>(this);
	}
	
	/**
	 * Add a component to this Entity
	 * @param	component
	 */
	public inline function add(component:Dynamic):Void
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
	 * Get whether Entity has component of type
	 * @return true if Entity has component of type
	 */
	public inline function exists<T>(type:Class<T>):Bool
	{
		return components.exists(Type.getClassName(type));
	}
	
	/**
	 * Get component with type T
	 * @return	Component of type T
	 */
	public inline function get<T>(type:Class<T>):T
	{
		var typeName:String = Type.getClassName(type);
		if (components.exists(typeName))
		{
			return components.get(typeName);
		}
		else
		{
			throw "Entity does not have component of type" + typeName + ".";
		}
	}
		
	/**
	 * Remove a component from this Entity
	 * @param	type
	 */
	public inline function remove(type:Dynamic):Void 
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