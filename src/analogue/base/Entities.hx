package analogue.base;
import analogue.core.IEntities;
import analogue.core.IEntity;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signal;
import hsl.haxe.Signaler;

class Entities implements IEntities
{
	private var all:List<IEntity>;
	public var added(default, null):Signaler<IEntity>;
	public var changed(default, null):Signaler<IEntity>;
	public var removed(default, null):Signaler<IEntity>;
	public var removing(default, null):Signaler<IEntity>;
	
	public function new()
	{
		all = new List<IEntity>();
		
		added = new DirectSignaler(this);
		changed = new DirectSignaler(this);
		removed = new DirectSignaler(this);
		removing = new DirectSignaler(this);
	}
	
	public function add(entity:IEntity):IEntity
	{
		all.add(entity);
		entity.added.bindAdvanced(onEntityComponentsChanged);
		entity.removed.bindAdvanced(onEntityComponentsChanged);
		
		added.dispatch(entity);
		
		return entity;
	}
	
	public function remove(entity:IEntity):IEntity
	{
		removing.dispatch(entity);
		entity.added.bindAdvanced(onEntityComponentsChanged);
		entity.removed.bindAdvanced(onEntityComponentsChanged);
	
		all.remove(entity);
		
		removed.dispatch(entity);
		
		return entity;
	}
	
	public function iterator():Iterator<IEntity>
	{
		return all.iterator();
	}
	
	private function onEntityComponentsChanged(signaler:Signal<Dynamic>):Void 
	{
		changed.dispatch(cast signaler.currentTarget);
	}
}