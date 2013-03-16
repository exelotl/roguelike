import sdl2/Event
import vamos/[Entity, Input]
import Level, Actor, Player
import structs/HashMap

//keyDirections: HashMap<

Controls: class extends Entity {
	
	level: Level
	player: Player
	
	added: func {
		level = state as Level
		player = level player
	}
	
	update: func (dt:Double) {
		action: Action
		
		if (level animating?) return
		
		match {
			case Input keyHeld(SDLK_UP) =>
				action = player directionAction(Direction UP)
			case Input keyHeld(SDLK_DOWN) =>
				action = player directionAction(Direction DOWN)
			case Input keyHeld(SDLK_LEFT) =>
				action = player directionAction(Direction LEFT)
			case Input keyHeld(SDLK_RIGHT) =>
				action = player directionAction(Direction RIGHT)
		}
		
		if (action) {
			player addAction(action)
			level turn()
		}
	}
	
}
