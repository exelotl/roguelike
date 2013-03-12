import math/Random
import vamos/[Engine, State]
import vamos/display/StateRenderer
import Map

Level: class extends State {
	
	map: Map
	
	init: func {
		
	}
	
	create: func {
		map = Map new(100, 100)
		for (x in 0..map w)
			for (y in 0..map h)
				map set(x, y, Random randInt(0, 5))
		add(map)
		map y = -1800
		map x = -1800
	}
	
	update: func (dt:Double) {
		super(dt)
		map y += 1
		map x += 1
	}
	
}