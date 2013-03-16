import structs/HashMap
import vamos/Entity
import vamos/graphics/Anim
import vamos/comps/Timer
import Actor, Level

Player: class extends Actor {
	
	init: func {
		brightness = 10
		anim = Anim new("player.png", 24, 28)
		anim y = -8
		anim play([10], 15)
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
	}
	
	move: func(action:Action) {
		super(action)
		anim reset() .play(getWalkAnim(facing), 10) .once()
		"%d, %d" printfln(mapX, mapY)
	}
	
	_foot := false
	
	getWalkAnim: func(d:Direction) -> Int[] {
		_foot = !_foot
		match d {
			case Direction UP    => return _foot ? ANIM_UP_1    : ANIM_UP_2
			case Direction RIGHT => return _foot ? ANIM_RIGHT_1 : ANIM_RIGHT_2
			case Direction DOWN  => return _foot ? ANIM_DOWN_1  : ANIM_DOWN_2
			case Direction LEFT  => return _foot ? ANIM_LEFT_1  : ANIM_LEFT_2
		}
		return ANIM_DOWN_1
	}
}

ANIM_UP_1    := static [1,2,0]
ANIM_RIGHT_1 := static [6,7,5]
ANIM_DOWN_1  := static [11,12,10]
ANIM_LEFT_1  := static [16,17,15]
ANIM_UP_2    := static [3,4,0]
ANIM_RIGHT_2 := static [8,9,5]
ANIM_DOWN_2  := static [13,14,10]
ANIM_LEFT_2  := static [18,19,15]

