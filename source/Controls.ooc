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
		if (Input keyPressed(SDLK_UP)) {
			action = Action new(ActionType MOVE)
			action direction = Direction UP
		}
		if (Input keyPressed(SDLK_DOWN)) {
			action = Action new(ActionType MOVE)
			action direction = Direction DOWN
		}
		if (Input keyPressed(SDLK_LEFT)) {
			action = Action new(ActionType MOVE)
			action direction = Direction LEFT
		}
		if (Input keyPressed(SDLK_RIGHT)) {
			action = Action new(ActionType MOVE)
			action direction = Direction RIGHT
		}
		
		if (action) {
			player addAction(action)
			level turn()
		}
	}
	
}
