package analogue;
import msignal.Signal;
import de.polygonal.ds.DLL;
import de.polygonal.ds.SLL;
import de.polygonal.ds.HashSet;

class Entities 
{
	private var list:DLL<Entity>;
	public var added(default, null):Signal1<Entity>;
	public var changed(default, null):Signal1<Entity>;
	public var removed(default, null):Signal1<Entity>;
	
	public function new()
	{
		list = new DLL<Entity>();
		
		added = new Signal1();
		changed = new Signal1();
		removed = new Signal1();
	}
	
	public function add(entity:Entity):Entity
	{
		list.append(entity);
		entity.added.add(onEntityComponentsChanged);
		entity.removed.add(onEntityComponentsChanged);
		
		added.dispatch(entity);
		
		return entity;
	}
	
	public function match(types:Array<Dynamic>):EntityList
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

private class Matcher extends HashSet<Entity>, implements EntityList
{
	
	private var entities:Entities;
	private var types:SLL<String>;
	public var added(default, null):Signal1<Entity>;
	public var changed(default, null):Signal1<Entity>;
	public var removed(default, null):Signal1<Entity>;
	
	public function new(entities:Entities, types:Array<Dynamic>)
	{
		super(8);
		
		this.entities = entities;
		this.types = new SLL<String>(types.length, types.length);
		
		for (type in types)
		{
			this.types.append(Type.getClassName(type));
		}
		
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
	
	override public function free():Void
	{
		super.free();
		
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
			if (!has(entity))
			{
				set(entity);
				
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
		if (has(entity))
		{
			remove(entity);
			
			removed.dispatch(entity);
		}
	}
	
	private function matches(entity:Entity):Bool
	{
		var node = types.head;
		
		while (node != null)
		{
			if (!entity.components.exists(node.val))
			{
				return false;
			}
			
			node = node.next;
		}
		
		return true;
	}
}