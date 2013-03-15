import math/Random
import structs/ArrayList
import Level, Map, Actor, Player
import mobs/Slime

Spawner: class {
	
	level: Level
	map: Map
	actors: ArrayList<Actor>
	player: Player
	
	
	init: func (=level) {
		actors = level actors
		map = level map
		player = level player
	}
	
	update: func {
		if (actors size < 20 && Random randInt(0, 10) == 0) {
			spawn()
		}
	}
	
	spawn: func {
		for (i in 0..30) {
			x := Random randRange(0, map w)
			y := Random randRange(0, map h)
			if (map get(x, y) spawnable?) {
				mob := makeMob()
				mob setPos(x, y)
				level add(mob)
				return
			}
		}
	}
	
	makeMob: func -> Actor {
		match (Random randInt(0, 1)) {
			case => Slime new()
		}
	}
}