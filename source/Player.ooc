import structs/HashMap
import vamos/Entity
import vamos/graphics/Anim
import vamos/comps/Timer
import Actor, Level, Map

Player: class extends Actor {
	
	init: func {
		brightness = 20
		anim = Anim new("player.png", 24, 28)
		anim y = -8
		anim play(IDLE_DOWN, 15).once()
		type = "player"
	}
	
	added: func {
		super()
	}
	
	update: func (dt:Double) {
		super(dt)
		if (!anim playing)
			anim play(getIdleAnim(facing), 15).once()
	}
	
	directionAction: func (d:Direction) -> Action {
		(x, y) := (mapX, mapY)
		d move(x&, y&)
		block := map get(x, y)
		target := level getActor(x, y)
		a: Action
		match {
			case target =>
				a = Action new(ActionType ATTACK)
				a target = target
			case block door? && block closed? =>
				a = Action new(ActionType OPEN)
			case =>
				a = Action new(ActionType MOVE)
		}
		a direction = d
		return a
	}
	
	move: func(action:Action) {
		super(action)
		anim reset() .play(getWalkAnim(facing), 10) .once()
	}
	
	_foot := false
	
	getWalkAnim: func(d:Direction) -> Int[] {
		_foot = !_foot
		match d {
			case Direction UP    => return _foot ? WALK_UP_1    : WALK_UP_2
			case Direction RIGHT => return _foot ? WALK_RIGHT_1 : WALK_RIGHT_2
			case Direction DOWN  => return _foot ? WALK_DOWN_1  : WALK_DOWN_2
			case Direction LEFT  => return _foot ? WALK_LEFT_1  : WALK_LEFT_2
		}
		return WALK_DOWN_1
	}
	
	getIdleAnim: func(d:Direction) -> Int[] {
		match d {
			case Direction UP    => return IDLE_UP
			case Direction RIGHT => return IDLE_RIGHT
			case Direction DOWN  => return IDLE_DOWN
			case Direction LEFT  => return IDLE_LEFT
		}
		return IDLE_DOWN
	}
}

IDLE_UP    := static [0]
IDLE_RIGHT := static [5]
IDLE_DOWN  := static [10]
IDLE_LEFT  := static [15]
WALK_UP_1    := static [1,2,0]
WALK_RIGHT_1 := static [6,7,5]
WALK_DOWN_1  := static [11,12,10]
WALK_LEFT_1  := static [16,17,15]
WALK_UP_2    := static [3,4,0]
WALK_RIGHT_2 := static [8,9,5]
WALK_DOWN_2  := static [13,14,10]
WALK_LEFT_2  := static [18,19,15]

