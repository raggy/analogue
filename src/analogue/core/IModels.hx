package analogue.core;
	
interface IModels
{
	function get<T>(type:Class<T>):T;
	function set<T>(type:Class<T>, instance:T):T;
	function iterator():Iterator<Dynamic>;
	function types():Iterator<String>;
}