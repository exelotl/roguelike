import Map
import vamos/Util
import structs/ArrayList
import math/Random
import math

Generator: class {
	
	map: Map
	dungeons: ArrayList<Dungeon>
	
	init: func (=map) {
		dungeons = ArrayList<Dungeon> new()
		dungeons add(Dungeon new(0, 0, map w, map h))
	}

	generate: func() {
		bsp()
		for (dungeon in dungeons) {
			// displayRoom(dungeon)
			generateRoom(dungeon)
		}
	}
	
	bsp: func () {
		running := true
		while (running) {
			newDungeons := ArrayList<Dungeon> new()
			for (dungeon in dungeons) {
				if (!dungeon splitted) {
					vertical: Bool = Random randInt(0, 1) as Bool
					if (vertical && dungeon h >= 16) {
						dungeon splitted = true
						dungeon destroyed = true
						y: Int = Random randInt(0, dungeon h - 16)
						newDungeons add(Dungeon new(dungeon x, dungeon y, dungeon w, 8 + y))
						newDungeons add(Dungeon new(dungeon x, dungeon y + 8 + y, dungeon w, dungeon h - 8 - y))
					} else if (!vertical && dungeon w >= 16) {
						dungeon splitted = true
						dungeon destroyed = true
						x: Int = Random randInt(0, dungeon w - 16)
						newDungeons add(Dungeon new(dungeon x, dungeon y, 8 + x, dungeon h))
						newDungeons add(Dungeon new(dungeon x + 8 + x, dungeon y, dungeon w - 8 - x, dungeon h))
					}
					if (dungeon w < 20 && dungeon h < 20) dungeon splitted = true
				}

			}
			for (dungeon in newDungeons) dungeons add(dungeon)
			if (newDungeons size == 0) running = false
		}
		
		deleteDungeons := ArrayList<Dungeon> new()
		for (dungeon in dungeons) {
			if (dungeon destroyed)
				deleteDungeons add(dungeon)
		}
		
		for (dungeon in deleteDungeons)
			dungeons remove(dungeon)
	}
	
	displayRoom: func (dungeon: Dungeon) {
		for (x in dungeon x..(dungeon x + dungeon w)) {
			map set(x, dungeon y, 1)
			map set(x, dungeon y + dungeon h, 1)
		}
		for (y in dungeon y..(dungeon y + dungeon h)) {
			map set(dungeon x, y, 1)
			map set(dungeon x + dungeon w, y, 1)
		}
	}
	
	generateRoom: func (dungeon: Dungeon) {
		points := ArrayList<Point> new()
		pointsA := ArrayList<Point> new()
		pointsB := ArrayList<Point> new()
		pointsC := ArrayList<Point> new()
		pointsD := ArrayList<Point> new()
		borderX: Int = Random randInt(2, dungeon w / 4)
		borderY: Int = Random randInt(2, dungeon h / 4)
		for (i in 0..4) {
			points: Int = Random randInt(2, 4)
			match (i) {
				case 0 =>
					for (i in 1..points) pointsA add(Point new(Random randInt(borderX, dungeon w - borderX), Random randInt(0, borderY)))
				case 1 =>
					for (i in 1..points) pointsB add(Point new(Random randInt(dungeon w - borderX, dungeon w), Random randInt(borderY, dungeon h - borderY)))
				case 2 =>
					for (i in 1..points) pointsC add(Point new(Random randInt(borderX, dungeon w - borderX), Random randInt(dungeon h - borderY, dungeon h)))
				case 3 =>
					for (i in 1..points) pointsD add(Point new(Random randInt(0, borderX), Random randInt(borderY, dungeon h - borderY)))
			}
		}
		pointsA sort(|a, b| a x > b x)
		pointsB sort(|a, b| a y > b y)
		pointsC sort(|a, b| a x < b x)
		pointsD sort(|a, b| a y < b y)
		for (point in pointsA) points add(point)
		for (point in pointsB) points add(point)
		for (point in pointsC) points add(point)
		for (point in pointsD) points add(point)
		for (i in 0..(points size - 1)) {
			addLine(points[i] clone(), points[i + 1] clone(), dungeon)
		}
		addLine(points[points size - 1] clone(), points[0] clone(), dungeon) // this line errors
	}
	
	addLine: func (p, q: Point, dungeon: Dungeon) {
		dx: Int = (p x - q x) abs()
		dy: Int = (p y - q y) abs()
		sx: Int = q x < p x ? 1 : -1
		sy: Int = q y < p y ? 1 : -1
		err: Int = dx - dy
		while (true){
			map set((q x + dungeon x) as UInt, (q y + dungeon y) as UInt, 1)
			if (q x == p x && q y == p y) break
			e2: Int = 2 * err
			if (e2 > -dx) {
				err -= dy
				q x += sx
			}
			if (e2 < dx) {
				err += dx
				q y += sy
			}
		}
	}
}

Dungeon: class extends Rect {
	
	splitted: Bool = false
	destroyed: Bool = false
	
	init: func (x, y, w, h: Double) {
		super(x, y, w, h)
	}
}