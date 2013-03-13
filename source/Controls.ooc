import sdl2/Event
import vamos/[Entity, Input]
import Level, Player

Controls: class extends Entity {
	
	level: Level
	player: Player
	
	added: func {
		level = state as Level
		player = level player
	}
	
	update: func (dt:Double) {
		if (Input keyPressed(SDLK_UP)) { player walkUp() }
		if (Input keyPressed(SDLK_DOWN)) { player walkDown() }
		if (Input keyPressed(SDLK_LEFT)) { player walkLeft() }
		if (Input keyPressed(SDLK_RIGHT)) { player walkRight() }
		
	}
	
}
