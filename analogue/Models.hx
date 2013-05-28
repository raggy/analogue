package analogue;

class Models 
{
	private var models:ClassMap<Class<Dynamic>, Dynamic>;
	
	public function new()
	{
		models = new ClassMap<Class<Dynamic>, Dynamic>();
	}
	
	public inline function get<T>(type:Class<T>):T
	{
		if (models.exists(type))
		{
			return models.get(type);
		}
		else
		{
			return set(type, Type.createInstance(type, []));
		}
	}
	
	public inline function set<T>(type:Class<T>, instance:T):T
	{
		models.set(type, instance);

		return instance;
	}
	
	public function iterator():Iterator<Dynamic>
	{
		return models.iterator();
	}
	
	public function types():Iterator<Class<Dynamic>>
	{
		return models.keys();
	}
}
