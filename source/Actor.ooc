import math, structs/LinkedList
import math/Random
import vamos/[Entity, Util]
import vamos/graphics/Anim
import main, Level, Map

// dungeon entities and stuff

Actor: class extends Entity {
	
	level: Level
	map: Map
	mapX: Int
	mapY: Int
	health: Int
	brightness: Int
	canHide: Bool
	inCombat: Bool
	facing: Direction
	speed: Speed
	actions := LinkedList<Action> new()
	
	animSpeed: Double = 170
	animWalking? := false
	animAttacking? := false
	anim: Anim
	
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
		
		graphic visible = visible?
	}
	
	visibility: Int {
		get { level darkness get(mapX, mapY) }
	}
	visible?: Bool {
		get { canHide ? (visibility > 15 || hasNeighbour("player")) : true }
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
	
	die: func (source:Actor) {
		level remove(this)
	}
	
	hasNeighbour: func (type:String) -> Bool {
		for (actor in level actors)
			if (actor != this \
			&& actor type == type \
			&& (actor mapX - mapX) abs() <= 1 \
			&& (actor mapY - mapY) abs() <= 1 )
				return true
		false
	}
	
	canMove: func~dir (d:Direction) -> Bool {
		(x, y) := (mapX, mapY)
		d move(x&, y&)
		return canMove(x, y)
	}
	
	canMove: func~pos (x, y:Int) -> Bool {
		map get(x, y) walkable? && !map hasFlag(x, y, BlockFlag OCCUPIED)
	}
	
	
	takeTurn: func {
		if (level == null) return
		
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
		a = Action new(ActionType MOVE)
		a direction = Direction random()
		addAction(a)
	}
	
	addAction: func (action:Action) {
		action source = this
		actions add(action)
	}
	
	doAction: func (action:Action) {
		if (action direction)
			facing = action direction
		
		match (action type) {
			case ActionType WAIT => wait(action)
			case ActionType MOVE => move(action)
			case ActionType OPEN => open(action)
			case ActionType ATTACK => attack(action)
			case => raise("No such action [%d]!" format(action type))
		}
	}
	
	move: func (action:Action) {
		if (canMove(facing)) {
			map unsetFlag(mapX, mapY, BlockFlag OCCUPIED)
			facing move(mapX&, mapY&)
			map setFlag(mapX, mapY, BlockFlag OCCUPIED)
		}
		action successful = true
		action complete = true
	}
	wait: func (action:Action) {
		action successful = true
		action complete = true
	}
	open: func (action:Action) {
		(x, y) := (mapX, mapY)
		action direction move(x&, y&)
		block := map get(x, y)
		if (block closed?) {
			map set(x, y, block open())
		}
		action successful = true
		action complete = true
	}
	attack: func (action:Action) {
		action target damage(1, this)
		(dx, dy) := (0, 0)
		facing move(dx&, dy&)
		x += dx * 20
		y += dy * 20
		action successful = true
		action complete = true
	}
	
}

Action: class {
	
	type: ActionType
	complete: Bool
	successful: Bool
	source: Actor
	target: Actor
	turns: Int = 1
	direction: Direction
	
	init: func (=type)
}

ActionType: enum {
	WAIT, MOVE, OPEN, ATTACK
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
	
	// move the coordinates one block in this direction
	move: func (x, y:Int*) {
		if (this & Direction UP) y@ -= 1
		if (this & Direction DOWN) y@ += 1
		if (this & Direction LEFT) x@ -= 1
		if (this & Direction RIGHT) x@ += 1
	}
}
