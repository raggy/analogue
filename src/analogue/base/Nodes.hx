package analogue.base;
import analogue.core.INode;
import analogue.core.IEntity;
import analogue.core.INodes;
import haxe.rtti.CType;
import haxe.rtti.Meta;
import haxe.rtti.XmlParser;
	
/**
 * Nodes manager
 * @author Benjamin Davis
 */
class Nodes implements INodes 
{
	
	private var descriptions:Hash<Description>;
	private var nodes:Hash<List<INode>>;
		
	public function new() 
	{
		descriptions = new Hash<Description>();
		nodes = new Hash<List<INode>>();
	}
	
	/**
	 * Destroy everything!
	 */
	public function destroy():Void
	{
		for (description in descriptions)
		{
			deregister(description.type);
		}
	}

	/**
	 * Get list of nodes
	 **/
	public function get<T:INode>(type:Class<T>):List<T>
	{
		var typeName:String = Type.getClassName(type);
		if (!nodes.exists(typeName))
		{
			register(type);
		}
		return cast nodes.get(typeName);
	}
		
	/**
	 * Create nodes for an entity
	 * @param	entity
	 */
	public function create(entity:IEntity):Void
	{
		for (description in descriptions)
		{
			if (satisfies(entity, description))
			{
				var node:INode = null;
				
				// Either get or create node
				if (entity.nodes.exists(description.typeName))
				{
					node = entity.nodes.get(description.typeName);
				}
				else
				{
					node = Type.createInstance(description.type, [entity]);
					entity.nodes.set(description.typeName, node);
					nodes.get(description.typeName).add(node);
				}

				// Import components
				for (fieldName in description.components.keys())
				{
					var componentDescription = description.components.get(fieldName);
					var component = entity.components.get(componentDescription.typeName);
					Reflect.setField(node, fieldName, component);
				}
			}
		}
	}
		
	/**
	 * Removes any nodes that are no longer valid from an entity
	 * @param	entity
	 */
	public function clean(entity:IEntity):Void
	{
		for (description in descriptions)
		{
			// If nodes exists for entity
			if (entity.nodes.exists(description.typeName))
			{
				var node = entity.nodes.get(description.typeName);
				
				// If node is no longer valid
				if (!satisfies(entity, description))
				{
					// Remove from nodes list
					var list = nodes.get(description.typeName);
					list.remove(node);
					// Remove from entity
					entity.nodes.remove(description.typeName);
				}
				else
				{
					// Import components
					for (fieldName in description.components.keys())
					{
						var componentDescription = description.components.get(fieldName);
						var component = entity.components.get(componentDescription.typeName);
						Reflect.setField(node, fieldName, component);
					}
				}
			}
		}
	}
		
	/**
	 * Remove nodes for an entity
	 * @param	entity
	 */
	public function remove(entity:IEntity):Void
	{
		for (typeName in entity.nodes.keys())
		{
			var node = entity.nodes.get(typeName);
			var list = nodes.get(typeName);
			list.remove(node);
			entity.nodes.remove(typeName);
		}
	}
	
	private function describe(type:Class<INode>):Description
	{
		var infos = new haxe.rtti.XmlParser().processElement(Xml.parse(Reflect.field(type, "__rtti")).firstElement());
		var classDef:Classdef = Type.enumParameters(infos)[0];
		var fieldsMeta = Meta.getFields(type);
		
		// Build hash of field name -> field type name
		var components:Hash<ComponentDescription> = new Hash<ComponentDescription>();
		for (fieldDescription in classDef.fields)
		{
			var fieldConstructorType = Type.enumConstructor(fieldDescription.type);
			
			if (fieldConstructorType == "CClass" || fieldConstructorType == "CEnum")
			{
				var fieldName = fieldDescription.name;
				var fieldTypeName = Type.enumParameters(fieldDescription.type)[0];
				var fieldOptional = false;
				
				var fieldMeta = Reflect.field(fieldsMeta, fieldName);
				if (fieldMeta != null)
				{
					fieldOptional = Reflect.hasField(fieldMeta, "optional");
				}
				
				components.set(fieldName, { typeName: fieldTypeName, optional: fieldOptional } );
			}
		}
		
		return { type: cast type, typeName: Type.getClassName(cast type), components: components };
	}
	
	private function register<T>(type:T):Void
	{
		var typeName:String = Type.getClassName(cast type);
		if (nodes.exists(typeName))
		{
			throw "Node type already registered: " + typeName;
		}
		else
		{
			descriptions.set(typeName, describe(cast type));
			nodes.set(typeName, cast new List<T>());
		}
	}
		
	private function deregister<T>(type:T):Void
	{
		var typeName:String = Type.getClassName(cast type);
		descriptions.remove(typeName);
		nodes.remove(typeName);
	}
	
	private function satisfies(entity:IEntity, description:Description):Bool
	{
		for (componentDescription in description.components)
		{
			// If a component isn't found
			if (!(componentDescription.optional || entity.components.exists(componentDescription.typeName)))
			{
				return false;
			}
		}
		
		// If all components were found
		return true;
	}
		
}

typedef Description =
{
	var components:Hash<ComponentDescription>;
	var type:Class<INode>;
	var typeName:String;
}

typedef ComponentDescription =
{
	var optional:Bool;
	var typeName:String;
}