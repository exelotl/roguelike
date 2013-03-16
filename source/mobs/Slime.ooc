import vamos/Entity
import vamos/graphics/Anim
import Actor, Level

Slime: class extends Actor {
	
	init: func {
		anim = Anim new("slime.png", 24, 12)
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
	}
}