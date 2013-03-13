import vamos/[Entity, Util]
import main

// dungeon entities and stuff

Actor: class extends Entity {
	
	mapX: Int
	mapY: Int
	animSpeed: Double = 200
	
	init: func {
		
	}
	
	update: func (dt:Double) {
		targetX := mapX*TILE_WIDTH
		targetY := mapY*TILE_HEIGHT
		if (x > targetX) x = max(targetX, x - animSpeed*dt)
		else if (x < targetX) x = min(targetX, x + animSpeed*dt)
		if (y > targetY) y = max(targetY, y - animSpeed*dt)
		else if (y < targetY) y = min(targetY, y + animSpeed*dt)
	}
	
	setPos: func(=mapX, =mapY) {
		x = mapX*TILE_WIDTH
		y = mapY*TILE_HEIGHT
	}
	
	walkUp: func { mapY -= 1 }
	walkDown: func { mapY += 1 }
	walkLeft: func { mapX -= 1 }
	walkRight: func { mapX += 1 }
	
}
