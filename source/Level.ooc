import vamos/State
import Map

Level: class extends State {
	
	map: Map
	
	init: func {
		
	}
	
	create: func {
		map = Map new(100, 100)
		add(map)
	}
	
}