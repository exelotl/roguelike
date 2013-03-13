

Action: class {
	
	type: ActionType
	source: Entity
	target: Entity
	direction: Direction
	
	init: func (=type, =data) {
		
	}
	
	execute: func {
		match type {
			case ActionType MOVE => move()
			case ActionType WAIT => wait()
			case ActionType ATTACK => attack()
		}
	}
	
	move: func {
		match direction {
			case Direction UP => source mapY -= 1
			case Direction DOWN => source mapY += 1
			case Direction LEFT => source mapX -= 1
			case Direction RIGHT => source mapX += 1
		}
	}
	wait: func {
		
	}
	attack: func {
		
	}
}

ActionType: enum {
	MOVE, WAIT, ATTACK
}

Direction: enum {
	UP    := static 0x0001
	RIGHT := static 0x0002
	DOWN  := static 0x0004
	LEFT  := static 0x0008
}
