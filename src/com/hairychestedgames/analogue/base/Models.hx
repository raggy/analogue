package com.hairychestedgames.analogue.base;
import com.hairychestedgames.analogue.core.IModels;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class Models implements IModels
{
	private var models:Hash<Dynamic>;
	
	public function new()
	{
		models = new Hash<Dynamic>();
	}
	
	public function get<T>(type:Class<T>):T
	{
		var typeName:String = Type.getClassName(type);
		
		if (!models.exists(typeName))
		{
			models.set(typeName, Type.createInstance(type, []));
		}
		
		return models.get(typeName);
	}
	
	public function set<T>(type:Class<T>, instance:T):T
	{
		var typeName:String = Type.getClassName(type);
		
		models.set(typeName, instance);

		return instance;
	}
	
	public function iterator():Iterator<Dynamic>
	{
		return models.iterator();
	}
	
	public function types():Iterator<String>
	{
		return models.keys();
	}
}
