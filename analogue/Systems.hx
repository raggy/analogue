package analogue;

import haxe.ds.ObjectMap;
import msignal.Signal;
	
/**
* Systems manager
* @author Benjamin Davis
*/
class Systems 
{
	private var systems:ObjectMap<Class<Dynamic>, System>;
	public var created(default, null):Signal1<System>;
	public var removed(default, null):Signal1<System>;
	
	public function new() 
	{
		systems = new ObjectMap<Class<Dynamic>, System>();
		created = new Signal1();
		removed = new Signal1();
	}
		
	/**
	 * Create a new system
	 */
	public function create<T:System>(type:Class<T>):T
	{
		if (systems.exists(type))
		{
			throw "System " + type + " already existed.";
		}
		else
		{
			var system:T = Type.createInstance(type, []);
			
			systems.set(type, system);
			created.dispatch(system);
			
			return system;
		}
	}
	
	public function get<T:System>(type:Class<T>):T
	{
		if (systems.exists(type))
		{
			return cast systems.get(type);
		}
		else
		{
			throw "System " + type + " does not exist.";
			
			return null;
		}
	}
		
	/**
	 * Remove a system
	 */
	public function remove<T:System>(type:Class<T>):T
	{
		if (systems.exists(type))
		{
			var system:T = cast systems.get(type);
			
			systems.remove(type);
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