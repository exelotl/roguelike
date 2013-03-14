import vamos/Entity
import vamos/graphics/SpriteMap
import Actor, Level

Slime: class extends Actor {
	
	init: func {
		
		anim = SpriteMap new("slime.png", 24, 12)
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
	}
}