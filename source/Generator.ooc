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
		for (dungeon in dungeons) generateRoom(dungeon)
	}
	
	bsp: func () {
		running := true
		while (running) {
			newDungeons := ArrayList<Dungeon> new()
			for (dungeon in dungeons) {
				if (!dungeon splitted) {
					vertical: Bool = Random randInt(0, 1) as Bool
					if (vertical && dungeon h >= 16) {
						y: Int = Random randInt(0, dungeon w - 16)
						newDungeons add(Dungeon new(dungeon x, dungeon y, dungeon w, 8 + y))
						newDungeons add(Dungeon new(dungeon x, dungeon y + 8 + y, dungeon w, dungeon h - 8 - y))
					} else if (!vertical && dungeon w >= 16) {
						x: Int = Random randInt(0, dungeon h - 16)
						newDungeons add(Dungeon new(dungeon x, dungeon y, 8 + x, dungeon h))
						newDungeons add(Dungeon new(dungeon x + 8 + x, dungeon y, dungeon w - 8 - x, dungeon h))
					}
					dungeon splitted = true
				}
			}
			for (dungeon in newDungeons) dungeons add(dungeon)
			if (newDungeons size == 0) running = false
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
		for (i in 0..3) {
			points: Int = Random randInt(1, 3)
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
		pointsA sort(|a, b| a x < b x)
		pointsB sort(|a, b| a y < b y)
		pointsC sort(|a, b| a x > b x)
		pointsD sort(|a, b| a y > b y)
		for (point in pointsA) points add(point)
		for (point in pointsB) points add(point)
		for (point in pointsC) points add(point)
		for (point in pointsD) points add(point)
		for (i in 0..(points size - 1)) {
			if (i != (points size - 1)) addLine(points[i] clone(), points[i + 1] clone())
			else addLine(points[i] clone(), points[0] clone())
		}
	}
	
	addLine: func (p, q: Point) {
		dx: Int = (p x - q x) abs()
		dy: Int = (p y - q y) abs()
		sx: Int = q x < p x ? 1 : -1
		sy: Int = q y < p y ? 1 : -1
		err: Int = dx - dy
		while (true){
			map set(q x as UInt, q y as UInt, 1)
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
	
	init: func (x, y, w, h: Double) {
		super(x, y, w, h)
	}
}