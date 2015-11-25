package analogue;
import msignal.Signal;

class Entity
{
	static var next:Int = 0;

	public var added(default, null):Signal2<Entity, Dynamic>;
	public var components(default, null):Map<String, Dynamic>;
	public var key:Int;
	public var removed(default, null):Signal2<Entity, Dynamic>;

	public function new()
	{
		added = new Signal2();
		components = new Map();
		key = next++;
		removed = new Signal2();
	}

	/**
	 * Add a component to this Entity
	 * @param	component
	 */
	public inline function add(component:Dynamic):Void
	{
		var type = Type.getClass(component);
		var typeName = Type.getClassName(type);

		if (components.exists(typeName))
		{
			throw 'Component of type $typeName already exists within $this';
		}
		else
		{
			components.set(typeName, component);
		}

		added.dispatch(this, component);
	}

	/**
	 * Get whether Entity has component of type
	 * @return true if Entity has component of type
	 */
	public inline function has(type:Class<Dynamic>):Bool
	{
		return components.exists(Type.getClassName(type));
	}

	/**
	 * Get component with type T
	 * @param   type    Type of component to get
	 * @return	        Component of type T
	 */
	public inline function get<T>(type:Class<T>):T
	{
		var typeName = Type.getClassName(type);

		if (components.exists(typeName))
		{
			return components.get(typeName);
		}
		else
		{
			throw '$this does not have component of type $typeName';
		}
	}

	/**
	 * Remove a component from this Entity
	 * @param	type
	 */
	public inline function remove(type:Class<Dynamic>):Void
	{
		var typeName = Type.getClassName(type);

		if (components.exists(typeName))
		{
			components.remove(typeName);
			removed.dispatch(this, components.get(typeName));
		}
		else
		{
			throw '$this does not have component of type $typeName';
		}
	}

	/**
	 * @private
	 */
	public inline function toString():String
	{
		return '[Entity key=$key]';
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
