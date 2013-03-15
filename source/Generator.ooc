import Map
import vamos/Util
import structs/ArrayList
import math/Random
import math

Generator: class {
	
	map: Map
	dungeons := ArrayList<Dungeon> new()
	paths := ArrayList<Path> new()
	
	roomW := 20
	roomH := 20
	roomPadding: Double = 0.1
	roomMargin := 20
	roomMinPoints := 2
	roomMaxPoints := 3
	
	init: func (=map) {
		dungeons add(Dungeon new(1, 1, map w-2, map h-2))
	}

	generate: func() {
		generateDungeons()
		for (dungeon in dungeons) {
			if (dungeon visible)
				generatePolygonRoom(dungeon)
		}
		generatePaths()
		removeAdjacentDoors()
	}
	
	generateDungeons: func {
		while (true) {
			newDungeons := ArrayList<Dungeon> new()
			for (dungeon in dungeons) {
				if (!dungeon split) {
					vertical := rand(0, 1) as Bool
					if (vertical && dungeon h >= roomH) {
						dungeon split = true
						dungeon visible = false
						y: Int = rand(0, dungeon h - roomH)
						d1 := Dungeon new(dungeon x, dungeon y, dungeon w, roomH*0.5 + y)
						d2 := Dungeon new(dungeon x, dungeon y + roomH*0.5 + y, dungeon w, dungeon h - roomH*0.5 - y)
						paths add(d1 pair(d2))
						newDungeons add(d1) .add(d2)
					} else if (!vertical && dungeon w >= roomW) {
						dungeon split = true
						dungeon visible = false
						x := rand(0, dungeon w - roomW)
						d1 := Dungeon new(dungeon x, dungeon y, roomW*0.5 + x, dungeon h)
						d2 := Dungeon new(dungeon x + roomW*0.5 + x, dungeon y, dungeon w - roomW*0.5 - x, dungeon h)
						paths add(d1 pair(d2))
						newDungeons add(d1) .add(d2)
					}
					if (dungeon w < roomW*1.2 && dungeon h < roomH*1.2) dungeon split = true
				}

			}
			for (dungeon in newDungeons) dungeons add(dungeon)
			if (newDungeons size == 0) break
		}
	}
	
	generatePaths: func {
		i := paths size
		while (i > 0) {
			i -= 1
			path := paths[i]
			x0 := path a x + path a w * 0.5
			y0 := path a y + path a h * 0.5
			x1 := path b x + path b w * 0.5
			y1 := path b y + path b h * 0.5
			if (x0 == x1) {
				for (y in y0..y1+1)
					plotPathBlock(x0, y)
			} else {
				for (x in x0..x1+1)
					plotPathBlock(x, y0)
			}
		}
	}
	
	plotPathBlock: func (x, y:UInt) {
		b := map get(x, y)
		map set(x, y, match b {
			case Block ROCK => Block PATH
			case Block WALL => Block DOOR
			case => b
		})
	}
	
	removeAdjacentDoors: func {
		for (x in 0..map w)
			for (y in 0..map h)
				if (map get(x, y) == Block DOOR && map countNeighbours(x, y, Block DOOR))
					map set(x, y, Block WALL)
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
	
	generateRoom: func (dungeon:Dungeon) {
		padding := roomPadding clamp(0, 0.5)
		margin := min(min(dungeon w * padding, dungeon h * padding), roomMargin)
		x0 := dungeon x + margin
		y0 := dungeon y + margin
		x1 := dungeon x + dungeon h - margin
		y1 := dungeon y + dungeon h - margin
		map drawFilledRect(x0, y0, x1, y1, Block FLOOR)
		map drawRect(x0-1, y0-1, x1+1, y1+1, Block WALL)
	}
	
	generatePolygonRoom: func (dungeon:Dungeon) {
		pointsA := ArrayList<Point> new()
		pointsB := ArrayList<Point> new()
		pointsC := ArrayList<Point> new()
		pointsD := ArrayList<Point> new()
		padding := roomPadding clamp(0, 0.5)
		minPoints := max(1, roomMinPoints)
		maxPoints := max(roomMaxPoints, minPoints)
		margin := min(min(dungeon w * padding, dungeon h * padding), roomMargin)
		borderX := rand(2, dungeon w * padding)
		borderY := rand(2, dungeon h * padding)
		for (i in 0..4) {
			numPoints: Int = rand(minPoints, maxPoints)
			match (i) {
				case 0 =>
					for (i in 1..numPoints) pointsA add(Point new(rand(margin + borderX, dungeon w - borderX - margin), rand(margin, margin + borderY)))
				case 1 =>
					for (i in 1..numPoints) pointsB add(Point new(rand(dungeon w - borderX - margin, dungeon w - margin), rand(borderY + margin, dungeon h - borderY - margin)))
				case 2 =>
					for (i in 1..numPoints) pointsC add(Point new(rand(margin + borderX, dungeon w - borderX - margin), rand(dungeon h - borderY - margin, dungeon h - margin)))
				case 3 =>
					for (i in 1..numPoints) pointsD add(Point new(rand(margin, borderX + margin), rand(borderY + margin, dungeon h - borderY - margin)))
			}
		}
		pointsA sort(|a, b| a x > b x)
		pointsB sort(|a, b| a y > b y)
		pointsC sort(|a, b| a x < b x)
		pointsD sort(|a, b| a y < b y)
		
		points := ArrayList<Point> new()
		for (point in pointsA) points add(point)
		for (point in pointsB) points add(point)
		for (point in pointsC) points add(point)
		for (point in pointsD) points add(point)
		for (i in 0..(points size - 1))
			addLine(points[i], points[i + 1], dungeon)
		addLine(points[points size - 1], points[0], dungeon)
	}
	
	addLine: func (p, q:Point, dungeon:Dungeon) {
		map drawLine(
			p x + dungeon x, p y + dungeon y,
			q x + dungeon x, q y + dungeon y,
			Block WALL)
	}
	
	rand: static func (a, b:Int) -> Int {
		if (a >= b) return a
		return Random randInt(a, b)
	}
}

Dungeon: class extends Rect {
	
	split := false
	visible := true
	parent: Dungeon
	sister: Dungeon
	paired := false
	
	init: func (x, y, w, h: Double) {
		super(x, y, w, h)
	}
	pair: func (d:Dungeon) -> Path {
		sister = d
		d sister = this
		paired = d paired = true
		return Path new(this, d)
	}
}

Path: class {
	a, b: Dungeon
	init: func (=a, =b)
}

//Path: class {
//	a, b:Point
//	init: func (x1,y1,x2,y2:Double) {
//		a = Point new(x1, y1)
//		b = Point new(x2, y2)
//	}
//}