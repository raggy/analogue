package com.hairychestedgames.analogue.core;
	
interface IModels
{
	function get<T>(type:Class<T>):T;
	function set<T>(type:Class<T>, instance:T):Void;
	function iterator():Iterator<Dynamic>;
	function types():Iterator<String>;
}