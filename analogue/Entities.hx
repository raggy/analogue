package analogue;
import msignal.Signal;

class Entities
{
	private var all:Map<Int, Entity>;
	public var added(default, null):Signal1<Entity>;
	public var changed(default, null):Signal1<Entity>;
	public var removed(default, null):Signal1<Entity>;

	public function new()
	{
		all = new Map();

		added = new Signal1();
		changed = new Signal1();
		removed = new Signal1();
	}

	public function add(entity:Entity):Entity
	{
		all.set(entity.key, entity);
		entity.added.add(onEntityComponentsChanged);
		entity.changed.add(onEntityComponentsChanged);
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
		entity.changed.remove(onEntityComponentsChanged);
		entity.removed.remove(onEntityComponentsChanged);
		all.remove(entity.key);

		return entity;
	}

	public function iterator():Iterator<Entity>
	{
		return all.iterator();
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
	public var debug:Bool;

	public function new(entities:Entities, types:Array<Class<Dynamic>>)
	{
		super();

		this.debug = false;
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
			if (matches(entity))
			{
				set(entity.key, entity);
			}
		}
	}

	public function free():Void
	{
		if (debug) trace('I\'m free!');
		entities.added.remove(onEntityChanged);
		entities.changed.remove(onEntityChanged);
		entities.removed.remove(onEntityRemoved);

		added.removeAll();
		changed.removeAll();
		removed.removeAll();
	}

	private function onEntityChanged(entity:Entity):Void
	{
		if (matches(entity))
		{
			if (!exists(entity.key))
			{
				if (debug) trace('$entity added');
				set(entity.key, entity);

				added.dispatch(entity);
			}
			else
			{
				if (debug) trace('$entity changed');
				changed.dispatch(entity);
			}
		}
		else
		{
			onEntityRemoved(entity);
		}
	}

	private function onEntityRemoved(entity:Entity):Void
	{
		if (exists(entity.key))
		{
			if (debug) trace('$entity removed so removing from list');
			remove(entity.key);

			removed.dispatch(entity);
		}
		else
		{
			var typeNames = new Array<String>();
			for (type in types)
			{
				typeNames.push(Type.getClassName(type));
			}
			if (debug) trace('$entity removed, but didn\'t match $typeNames');
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
