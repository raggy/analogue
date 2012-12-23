package analogue;

class Context
{
	public var entities(default, null):Entities;
	public var models(default, null):Models;
	public var systems(default, null):Systems;
	
	public function new()
	{
		entities = new Entities();
		models = new Models();
		systems = new Systems();
		
		systems.created.bind(onSystemCreated);
		systems.removed.bind(onSystemRemoved);
	}
	
	private function onSystemCreated(system:System):Void
	{
		Reflect.setField(system, "context", this);
		system.initialise();
	}
	
	private function onSystemRemoved(system:System):Void
	{
		system.destroy();
		Reflect.setField(system, "context", null);
	}
}