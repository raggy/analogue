package analogue;

class Models
{
	private var models:Map<String, Dynamic>;

	public function new()
	{
		models = new Map();
	}

	public inline function get<T>(type:Class<T>):T
	{
		var typeName = Type.getClassName(type);

		if (models.exists(typeName))
		{
			// trace('${Type.getClassName(type)} already exists');
			return models.get(typeName);
		}
		else
		{
			// trace('${Type.getClassName(type)} doesn\'t exist, creating one');
			return set(type, Type.createInstance(type, []));
		}
	}

	public inline function set<T>(type:Class<T>, instance:T):T
	{
		var typeName = Type.getClassName(type);

		models.set(typeName, instance);

		return instance;
	}

	public function iterator():Iterator<Dynamic>
	{
		return models.iterator();
	}
}
