import structs/LinkedList
import math/Random
import vamos/[Entity, Util]
import vamos/graphics/SpriteMap
import main, Level, Map

// dungeon entities and stuff

Actor: class extends Entity {
	
	level: Level
	map: Map
	mapX: Int
	mapY: Int
	health: Int
	facing: Direction
	speed: Speed
	actions := LinkedList<Action> new()
	
	animSpeed: Double = 200
	anim: SpriteMap
	
	init: func {
		
	}
	
	added: func {
		level = state as Level
		map = level map
		graphic = anim
	}
	
	update: func (dt:Double) {
		targetX := mapX * TILE_W
		targetY := mapY * TILE_H
		if (x > targetX) x = max(targetX, x - animSpeed*dt)
		else if (x < targetX) x = min(targetX, x + animSpeed*dt)
		if (y > targetY) y = max(targetY, y - animSpeed*dt)
		else if (y < targetY) y = min(targetY, y + animSpeed*dt)
	}
	
	setPos: func (=mapX, =mapY) {
		x = mapX * TILE_W
		y = mapY * TILE_H
	}
	
	damage: func (amount:Int, source:Actor) {
		health -= amount
		if (health <= 0) {
			health = 0
			die(source)
		}
	}
	
	die: func (source:Actor)
	
	canMove: func~dir (dir:Direction) -> Bool {
		(x, y) := (mapX, mapY)
		if (dir & Direction UP) y -= 1
		if (dir & Direction DOWN) y += 1
		if (dir & Direction LEFT) x -= 1
		if (dir & Direction RIGHT) x += 1
		canMove(x, y)
	}
	
	canMove: func~pos (x, y:Int) -> Bool {
		!map get(x, y) solid?
	}
	
	
	takeTurn: func {
		if (actions size == 0)
			decideAction()
			
		action := actions first()
		action complete = false
		
		while (!action complete)
			doAction(action)
		
		action turns -= 1
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
		facing = action direction
		if (canMove(facing)) {
			match (facing) {
				case Direction UP => mapY -= 1
				case Direction DOWN => mapY += 1
				case Direction LEFT => mapX -= 1
				case Direction RIGHT => mapX += 1
			}
		}
		action complete = true
	}
	wait: func (action:Action) {
		action complete = true
	}
	attack: func (action:Action) {
		action complete = true
	}
	
}

Action: class {
	
	type: ActionType
	complete: Bool
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
