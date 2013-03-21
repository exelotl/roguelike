import vamos/Entity
import vamos/graphics/Anim
import Actor, Level

Slime: class extends Actor {
	
	init: func {
		anim = Anim new("slime.png", 24, 12)
		anim play([0,1], 2)
		anim y = -1
		canHide = true
		health = 5
		type = "slime"
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
	}
}
