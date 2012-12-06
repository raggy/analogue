package analogue.base;
import analogue.core.ISystem;
import analogue.core.ISystems;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
	
/**
* Systems manager
* @author Benjamin Davis
*/
class Systems implements ISystems
{
	private var systems:Hash<ISystem>;
	public var created(default, null):Signaler<ISystem>;
	public var removed(default, null):Signaler<ISystem>;
	
	public function new() 
	{
		systems = new Hash<ISystem>();
		created = new DirectSignaler(this);
		removed = new DirectSignaler(this);
	}
		
	/**
	 * Create a new system
	 */
	public function create(type:Class<ISystem>):ISystem
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			throw "System " + type + " already existed.";
		}
		else
		{
			var system:ISystem = Type.createInstance(type, []);
			
			systems.set(typeName, system);
			created.dispatch(system);
			
			return system;
		}
	}
	
	public function get<T:ISystem>(type:Class<T>):T
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
	public function remove(type:Class<ISystem>):ISystem
	{
		var typeName:String = Type.getClassName(type);
		
		if (systems.exists(typeName))
		{
			var system:ISystem = systems.get(typeName);
			
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