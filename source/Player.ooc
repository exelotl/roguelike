import vamos/Entity
import vamos/graphics/SpriteMap
import Actor, Level

Player: class extends Actor {
	
	level: Level
	anim := SpriteMap new("player.png", 24, 24)
	
	init: func {
		
		graphic = anim
		graphic y -= 14
	}
	
	added: func {
		level = state as Level
	}
	
	update: func (dt:Double) {
		super(dt)
	}
	
	walkUp: func { super(); level turn() }
	walkDown: func { super(); level turn() }
	walkLeft: func { super(); level turn() }
	walkRight: func { super(); level turn() }
}