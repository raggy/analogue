package analogue;
import msignal.Signal;

class Entities
{
	private var list:Array<Entity>;
	public var added(default, null):Signal1<Entity>;
	public var changed(default, null):Signal1<Entity>;
	public var removed(default, null):Signal1<Entity>;

	public function new()
	{
		list = new Array<Entity>();

		added = new Signal1();
		changed = new Signal1();
		removed = new Signal1();
	}

	public function add(entity:Entity):Entity
	{
		list.push(entity);
		entity.added.add(onEntityComponentsChanged);
		entity.removed.add(onEntityComponentsChanged);

		added.dispatch(entity);

		return entity;
	}

	public function match(types:Array<Class<Dynamic>>):EntityList
	{
		return new Matcher(this, types);
	}

	public function remove(entity:Entity):Entity
	{
		removed.dispatch(entity);

		entity.added.remove(onEntityComponentsChanged);
		entity.removed.remove(onEntityComponentsChanged);
		list.remove(entity);

		return entity;
	}

	public function iterator():Iterator<Entity>
	{
		return list.iterator();
	}

	private function onEntityComponentsChanged(entity:Entity, component:Dynamic):Void
	{
		changed.dispatch(entity);
	}
}

private class Matcher extends haxe.ds.IntMap<Entity> implements EntityList
{

	private var entities:Entities;
	private var types:Array<Class<Dynamic>>;
	public var added(default, null):Signal1<Entity>;
	public var changed(default, null):Signal1<Entity>;
	public var removed(default, null):Signal1<Entity>;

	public function new(entities:Entities, types:Array<Class<Dynamic>>)
	{
		super();

		this.entities = entities;
		this.types = types;

		entities.added.addWithPriority(onEntityChanged, 100);
		entities.changed.addWithPriority(onEntityChanged, 100);
		entities.removed.addWithPriority(onEntityRemoved, -100);

		added = new Signal1();
		changed = new Signal1();
		removed = new Signal1();

		for (entity in entities)
		{
			onEntityChanged(entity);
		}
	}

	public function free():Void
	{
		entities.added.remove(onEntityChanged);
		entities.changed.remove(onEntityChanged);
		entities.removed.remove(onEntityRemoved);

		added.removeAll();
		changed.removeAll();
		removed.removeAll();
	}

	private inline function onEntityChanged(entity:Entity):Void
	{
		if (matches(entity))
		{
			if (!exists(entity.key))
			{
				set(entity.key, entity);

				added.dispatch(entity);
			}
			else
			{
				changed.dispatch(entity);
			}
		}
		else
		{
			onEntityRemoved(entity);
		}
	}

	private inline function onEntityRemoved(entity:Entity):Void
	{
		if (exists(entity.key))
		{
			remove(entity.key);

			removed.dispatch(entity);
		}
	}

	private function matches(entity:Entity):Bool
	{
		for (type in types)
		{
			if (!entity.has(type))
			{
				return false;
			}
		}

		return true;
	}
}
