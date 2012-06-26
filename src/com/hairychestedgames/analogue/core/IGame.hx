package com.hairychestedgames.analogue.core;

interface IGame 
{
	var entities(default, null):IEntities;
	var models(default, null):IModels;
	var nodes(default, null):INodes;
	var systems(default, null):ISystems;
}