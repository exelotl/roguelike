import vamos/Entity
import vamos/graphics/SpriteMap
import Actor

Player: class extends Actor {
	
	anim := SpriteMap new("player.png", 24, 24)
	
	init: func {
		
		graphic = anim
		graphic y -= 14
	}
	
	update: func (dt:Double) {
		super(dt)
	}
	
}