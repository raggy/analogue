package analogue;

import de.polygonal.ds.Set;
import msignal.Signal;

interface EntityList extends Set<Entity>
{
	var added(default, null):Signal1<Entity>;
	var changed(default, null):Signal1<Entity>;
	var removed(default, null):Signal1<Entity>;
}
