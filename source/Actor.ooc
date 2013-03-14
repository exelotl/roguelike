import structs/LinkedList
import math/Random
import vamos/[Entity, Util]
import main

// dungeon entities and stuff

Actor: class extends Entity {
	
	mapX: Int
	mapY: Int
	facing: Direction
	speed: Speed
	actions := LinkedList<Action> new()
	
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
	
	setPos: func (=mapX, =mapY) {
		x = mapX*TILE_WIDTH
		y = mapY*TILE_HEIGHT
	}
	
	takeTurn: func {
		if (actions size == 0)
			decideAction()
			
		action := actions first()
		doAction(action)
		
		if (action turns <= 0)
			actions removeAt(0)
	}
	
	decideAction: func {
		a:Action
		match (Random randInt(0, 1)) {
			case 1 =>
				a = Action new(ActionType MOVE)
				a direction = Direction random()
			case =>
				a = Action new(ActionType WAIT)
		}
		addAction(a)
	}
	
	addAction: func (action:Action) {
		action source = this
		actions add(action)
	}
	
	doAction: func (action:Action) {
		match (action type) {
			case ActionType MOVE => move(action)
			case ActionType WAIT => wait(action)
			case ActionType ATTACK => attack(action)
		}
	}
	
	move: func (action:Action) {
		match (action direction) {
			case Direction UP => mapY -= 1
			case Direction DOWN => mapY += 1
			case Direction LEFT => mapX -= 1
			case Direction RIGHT => mapX += 1
		}
		action turns -= 1
	}
	wait: func (action:Action) {
		action turns -= 1
	}
	attack: func (action:Action) {
		action turns -= 1
	}
	
}

Action: class {
	
	type: ActionType
	source: Entity
	target: Entity
	turns: UInt = 1
	direction: Direction
	
	init: func (=type)
}

ActionType: enum {
	MOVE, WAIT, ATTACK
}

Speed: enum {
	XSLOW, SLOW, NORMAL, FAST, XFAST
}

Direction: cover from Int {
	UP    : static Direction = 0x01
	RIGHT : static Direction = 0x02
	DOWN  : static Direction = 0x04
	LEFT  : static Direction = 0x08
	
	random: static func -> Direction {
		1 << Random randInt(0, 3)
	}
}
