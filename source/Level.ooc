import math/Random
import vamos/[Engine, State]
import vamos/display/StateRenderer
import Map, Player, Controls

Level: class extends State {
	
	map: Map
	player: Player
	controls: Controls
	
	renderer: StateRenderer
	
	init: func {
		
	}
	
	create: func {
		renderer = engine stateRenderer
		
		map = Map new(100, 100)
		for (x in 0..map w)
			for (y in 0..map h)
				map set(x, y, Random randInt(0, 5))
		add(map)
		
		player = Player new()
		player setPos(50, 50)
		add(player)
		
		controls = Controls new()
		add(controls)
	}
	
	update: func (dt:Double) {
		super(dt)
		renderer camX = player x - renderer width/2
		renderer camY = player y - renderer height/2
	}
	
}