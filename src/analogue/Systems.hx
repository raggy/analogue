package analogue;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
	
/**
* Systems manager
* @author Benjamin Davis
*/
class Systems 
{
	private var systems:Hash<System>;
	public var created(default, null):Signaler<System>;
	public var removed(default, null):Signaler<System>;
	
	public function new() 
	{
		systems = new Hash<System>();
		created = new DirectSignaler(this);
		removed = new DirectSignaler(this);
	}
		
	/**
	 * Create a new system
	 */
	public function create(type:Class<System>):System
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			throw "System " + type + " already existed.";
		}
		else
		{
			var system:System = Type.createInstance(type, []);
			
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
	public function remove(type:Class<System>):System
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			var system:System = systems.get(typeName);
			
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