package analogue.base;
import analogue.core.IEntity;
import analogue.core.INode;

/**
 * Base class for a node
 * @author Benjamin Davis
 */
class Node implements INode, implements haxe.rtti.Infos
{
		
	public var entity(default, null):IEntity;
	
	public function new(entity:IEntity)
	{
		this.entity = entity;
	}
}