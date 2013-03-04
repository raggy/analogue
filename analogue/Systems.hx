package analogue;

import msignal.Signal;
	
/**
* Systems manager
* @author Benjamin Davis
*/
class Systems 
{
	private var systems:Hash<System>;
	public var created(default, null):Signal1<System>;
	public var removed(default, null):Signal1<System>;
	
	public function new() 
	{
		systems = new Hash<System>();
		created = new Signal1();
		removed = new Signal1();
	}
		
	/**
	 * Create a new system
	 */
	public function create<T:System>(type:Class<T>):T
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			throw "System " + type + " already existed.";
		}
		else
		{
			var system:T = Type.createInstance(type, []);
			
			systems.set(typeName, system);
			created.dispatch(system);
			
			return system;
		}
	}
	
	public function get<T:System>(type:Class<T>):T
	{
		var typeName:String = Type.getClassName(type);
	
		if (systems.exists(typeName))
		{
			return cast systems.get(typeName);
		}
		else
		{
			throw "System " + type + " does not exist.";
		}
	}
		
	/**
	 * Remove a system
	 */
	public function remove<T:System>(type:Class<T>):T
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			var system:T = cast systems.get(typeName);
			
			systems.remove(typeName);
			removed.dispatch(system);
			
			return system;
		}
		else
		{
			throw "System " + type + " does not exist.";
		}
	}
		
	/**
	 * Remove all systems
	 */
	public function destroy():Void
	{
		for (system in systems) 
		{
			remove(Type.getClass(system));
		}
	}
		
}