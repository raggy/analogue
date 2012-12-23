package analogue;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signal;
import hsl.haxe.Signaler;
import de.polygonal.ds.DLL;
import de.polygonal.ds.HashSet;

class Entities 
{
	private var list:DLL<Entity>;
	public var added(default, null):Signaler<Entity>;
	public var changed(default, null):Signaler<Entity>;
	public var removed(default, null):Signaler<Entity>;
	
	public function new()
	{
		list = new DLL<Entity>();
		
		added = new DirectSignaler(this);
		changed = new DirectSignaler(this);
		removed = new DirectSignaler(this);
	}
	
	public function add(entity:Entity):Entity
	{
		list.append(entity);
		entity.added.bindAdvanced(onEntityComponentsChanged);
		entity.removed.bindAdvanced(onEntityComponentsChanged);
		
		added.dispatch(entity);
		
		return entity;
	}
	
	public function match(types:Array<Dynamic>):EntityList
	{
		return new MatcherImplementation(this, types);
	}
	
	public function remove(entity:Entity):Entity
	{
		removed.dispatch(entity);
		
		entity.added.bindAdvanced(onEntityComponentsChanged);
		entity.removed.bindAdvanced(onEntityComponentsChanged);
		list.remove(entity);
		
		return entity;
	}
	
	public function iterator():Iterator<Entity>
	{
		return list.iterator();
	}
	
	private function onEntityComponentsChanged(signal:Signal<Dynamic>):Void 
	{
		changed.dispatch(cast signal.currentTarget);
	}
}

private class MatcherImplementation extends HashSet<Entity>, implements EntityList
{
	
	private var entities:Entities;
	private var types:Hash<Void>;
	
	public function new(entities:Entities, types:Array<Dynamic>)
	{
		super(8);
		
		this.entities = entities;
		this.types = new Hash<Void>();
		
		for (type in types)
		{
			this.types.set(Type.getClassName(type), null);
		}
		
		entities.added.bind(onEntityChanged);
		entities.changed.bind(onEntityChanged);
		entities.removed.bind(onEntityRemoved);
		
		for (entity in entities)
		{
			onEntityChanged(entity);
		}
	}
	
	override public function free():Void
	{
		super.free();
		
		entities.added.unbind(onEntityChanged);
		entities.changed.unbind(onEntityChanged);
		entities.removed.unbind(onEntityRemoved);
	}
	
	private function onEntityChanged(entity:Entity):Void
	{
		if (matches(entity))
		{
			set(entity);
		}
		else
		{
			remove(entity);
		}
	}
	
	private function onEntityRemoved(entity:Entity):Void
	{
		remove(entity);
	}
	
	private inline function matches(entity:Entity):Bool
	{
		for (typeName in types.keys())
		{
			if (!entity.components.exists(typeName))
			{
				return false;
			}
		}
		return true;
	}
}