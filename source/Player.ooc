import vamos/Entity
import vamos/graphics/SpriteMap
import Actor, Level

Player: class extends Actor {
	
	init: func {
		
		anim = SpriteMap new("player.png", 24, 28)
		anim y = -8
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
	}
	
	move: func(action:Action) {
		super(action)
		"%d, %d" printfln(mapX, mapY)
	}
}