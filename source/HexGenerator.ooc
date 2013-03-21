import math, math/Random
import Map

HexGenerator: class {
	
	map:Map	
	roomDensity:Double = 0.01
	
	init: func (=map)
	
	generate: func {
		for (a in 0..map w * map h * roomDensity)
			genRoom(Random randRange(0, map w), Random randRange(0, map h), Random randInt(5, 9), Random randInt(5, 9))
		
		for (x in 0..map w)
			for (y in 0..map h)
				if (map get(x, y) == Block FLOOR && isExposed(x, y))
					map set(x, y, Block WALL)
		
		for (x in 0..map w)
			for (y in 0..map h)
				if (map get(x, y) door? && !isDoorValid(x, y))
					map set(x, y, Block PATH)
	}
	
	genRoom: func (x, y, maxW, maxH: UInt) {
		if (map get(x, y) != Block ROCK) return
		
		(leftSide, rightSide) := (x, x)
		(topSide, bottomSide) := (y, y)
		
		while (true) {
			widthLeft := maxW - (leftSide-rightSide) abs() - 1
			heightLeft := maxH - (topSide-bottomSide) abs() - 1
			
			if (widthLeft <= 0 && heightLeft <= 0) break
			
			hadChange := false
			
			if (heightLeft > 0 && topSide+1 < map h) {
				canMove := true
				
				for (x in leftSide..rightSide) {
					if (!map get(x, topSide+1) solid?) {
						canMove = false
						break
					}
				}
				if (canMove) {
					hadChange = true
					topSide += 1
					heightLeft -= 1
				}
			}
			if (heightLeft > 0 && bottomSide > 0) {
				canMove := true
				for (x in leftSide..rightSide) {
					if (!map get(x, bottomSide-1) solid?) {
						canMove = false
						break
					}
				}
				if (canMove) {
					hadChange = true
					bottomSide -= 1
				}
			}
			if (widthLeft > 0 && rightSide+1 < map w) {
				canMove := true
				for (y in bottomSide..topSide) {
					if (!map get(rightSide+1, y) solid?) {
						canMove = false
					}
				}
				if (canMove) {
					hadChange = true
					rightSide += 1
					widthLeft -= 1
				}
			}
			if (widthLeft > 0 && leftSide > 0) {
				canMove := true
				for (y in bottomSide..topSide) {
					if (!map get(leftSide-1, y) solid?) {
						canMove = false
						break
					}
				}
				if (canMove) {
					hadChange = true
					leftSide -= 1
				}
			}
			if (!hadChange) break
		}
		leftSide += 1
		rightSide -= 1
		bottomSide += 1
		topSide -= 1
		
		if ((leftSide-rightSide) abs() < 4 || (topSide-bottomSide) abs() < 4) return
		
		for (x in leftSide..rightSide)
			for (y in bottomSide..topSide)
				map set(x, y, Block FLOOR)
				
		genHallway(leftSide, Random randInt(bottomSide+1, topSide-1), -1, 0);
		genHallway(rightSide, Random randInt(bottomSide+1, topSide-1), 1, 0);
		genHallway(Random randInt(leftSide+1, rightSide-1), bottomSide, 0, -1);
		genHallway(Random randInt(leftSide+1, rightSide-1), topSide, 0, 1);
	}
	
	genHallway: func (x, y, dirX, dirY:Int) {
		if (dirX != 0 && dirY != 0) return
		if (dirX == 0 && dirY == 0) return
		(startX, endX) := (x, x)
		(startY, endY) := (y, y)
		valid := false
		
		while (!valid) {
			endX += dirX
			endY += dirY
			if (endX < 0 || endX >= map w || endY < 0 || endY >= map h) break
			if (map get(endX, endY) == Block FLOOR && !isExposed(endX, endY)) {
				valid = true
				endX -= dirX
				endY -= dirY
			}
		}
		
		if (valid) {
			if (endX < startX) (startX, endX) = (endX, startX)
			if (endY < startY) (startY, endY) = (endY, startY)
			
			for (x in startX-1..endX+1)
				for (y in startY-1..endY+1)
					map set(x, y, Block PATH)
			
			map set(startX, startY, dirX==0 ? Block DOOR_CLOSED_H : Block DOOR_CLOSED_V)
			map set(endX, endY, dirX==0 ? Block DOOR_CLOSED_H : Block DOOR_CLOSED_V)
		}
	}
	
	isExposed: func (x, y:Int) -> Bool {
		if (x == 0 || y == 0 || x == map w-1 || y == map h-1) return true
		return (
		(map get(x+1, y+1) == Block ROCK) as Int +
		(map get(x+1, y)   == Block ROCK) as Int +
		(map get(x+1, y-1) == Block ROCK) as Int +
		(map get(x,   y+1) == Block ROCK) as Int +
		(map get(x,   y-1) == Block ROCK) as Int +
		(map get(x-1, y+1) == Block ROCK) as Int +
		(map get(x-1, y)   == Block ROCK) as Int +
		(map get(x-1, y-1) == Block ROCK) as Int ) != 0
	}
	
	isDoorValid: func (x, y:Int) -> Bool {
		if (x == 0 || y == 0 || x == map w-1 || y == map h-1 || !map get(x, y) door?) return false
		
		return (map get(x, y-1) == Block WALL && map get(x, y+1) == Block WALL &&
				map get(x-1, y) == Block FLOOR && map get(x+1, y) == Block FLOOR) \
			|| (map get(x-1, y) == Block FLOOR && map get(x+1, y) == Block FLOOR &&
				map get(x, y-1) == Block WALL && map get(x, y+1) == Block WALL)
	}
	
}