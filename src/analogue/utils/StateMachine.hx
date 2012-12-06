package analogue.utils;

/**
 * Simple state machine
 * @author Benjamin Davis
 */

class StateMachine<T> implements haxe.rtti.Generic
{
	
	private var states:Hash<List<Void->Void>>;
	public var state(default, setState):T;
	
	public function new(type:Enum<T>) 
	{
		states = new Hash<List<Void->Void>>();
		
		for (value in Type.allEnums(type))
		{
			add(value);
		}
	}

	public function bind(state:T, listener:Void->Void):Void
	{
		var list:List < Void->Void > = getStateListeners(state);
		
		list.add(listener);
	}
	
	private function setState(value:T):T
	{
		if (value != state)
		{
			state = value;
			
			callStateListeners(state);
		}
		
		return state;
	}
	
	public function unbind(state:T, listener:Void->Void):Void
	{
		var list:List < Void->Void > = getStateListeners(state);
		
		list.remove(listener);
	}
	
	private function add(state:T):Void
	{
		var key:String = Std.string(state);
		
		if (states.exists(key))
		{
			throw "State already exists: " + state;
		}
		else
		{
			states.set(key, new List<Void->Void>());
		}
	}
	
	private function getStateListeners(state:T):List<Void->Void>
	{
		var key:String = Std.string(state);
		
		if (states.exists(key))
		{
			return states.get(key);
			
		}
		else
		{
			throw "State does not exist: " + state;
		}
	}
	
	private function callStateListeners(state:T):Void
	{
		for (listener in getStateListeners(state))
		{
			listener();
		}
	}
	
}