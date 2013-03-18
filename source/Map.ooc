import structs/ArrayList
import vamos/[Entity, Util]
import vamos/graphics/TileMap
import main, BlockRow

Map: class extends Entity {
	
	data: Block*
	w, h: UInt // size in tiles
	
	tilemap: TileMap
	
	init: func (=w, =h) {
		data = gc_malloc(w * h * UInt size) as Block*
		clear(Block ROCK)
		
		tilemap = TileMap new("tiles.png", w, h, TILE_W, TILE_H)
		tilemap data = data
		graphic = tilemap
	}
	
	added: func {
		for (i in 0..h)
			state add(BlockRow new(data, i, w))
	}
	
	get: inline func(x, y:UInt) -> Block {
		(x < w && y < h) ? data[x + y*w] : Block EMPTY
	}
	set: inline func(x, y:UInt, val:Block) {
		if (x < w && y < h)
			data[x + y*w] = val
	}

	drawLine: func (x, y, x2, y2:Int, val:Block) {
		dx := (x2 - x) abs()
		dy := (y2 - y) abs()
		sx := x < x2 ? 1 : -1
		sy := y < y2 ? 1 : -1
		
		if (dx > dy) {
			d := dy - dx * 0.5

			while (x != x2) {
				set(x, y, val)
				if (d > 0 || (d == 0 && sx == 1)) {
					y += sy
					d -= dx
				}
				x += sx
				d += dy
			}
		} else {
			d := dx - dy * 0.5

			while (y != y2) {
				set(x, y, val)
				if (d > 0 || (d == 0 && sy == 1)) {
					x += sx
					d -= dy
				}
				y += sy
				d += dx
			}
		}
		set(x, y, val)
	}
	
	floodFill: func (x, y:UInt, val:Block) {
		set(x, y, Block EMPTY)
	}
	
	drawFilledRect: func(x0, y0, x1, y1:UInt, val:Block) {
		for (x in x0..x1+1)
			for (y in y0..y1+1)
				set(x, y, val)
	}
	
	drawRect: func(x0, y0, x1, y1:UInt, val:Block) {
		for (x in x0..x1+1) set(x, y0, val)
		for (x in x0..x1+1) set(x, y1, val)
		for (y in y0+1..y1) set(x0, y, val)
		for (y in y0+1..y1) set(x1, y, val)
	}
	
	countRect: func (x0, y0, x1, y1:UInt, val:Block) -> Int {
		n := 0
		for (x in x0..x1+1)
			for (y in y0..y1+1)
				if (get(x, y) == val) n += 1
		return n
	}
	countNeighbours: func (x, y:UInt, val:Block) -> Int {
		(get(x+1,y+1) == val) as Int +
		(get(x,  y+1) == val) as Int +
		(get(x-1,y+1) == val) as Int +
		(get(x+1,y  ) == val) as Int +
		(get(x-1,y  ) == val) as Int +
		(get(x+1,y-1) == val) as Int +
		(get(x,  y-1) == val) as Int +
		(get(x-1,y-1) == val) as Int
	}
	countNeighbours: func~condition (x, y:UInt, f:Func(Block)->Bool) -> Int {
		f(get(x+1,y+1)) as Int +
		f(get(x,  y+1)) as Int +
		f(get(x-1,y+1)) as Int +
		f(get(x+1,y  )) as Int +
		f(get(x-1,y  )) as Int +
		f(get(x+1,y-1)) as Int +
		f(get(x,  y-1)) as Int +
		f(get(x-1,y-1)) as Int
	}
		
	clear: func (val:Block) {
		for (x in 0..w)
			for (y in 0..h)
				set(x, y, val)
	}
}

Block: cover from UInt {
	
	EMPTY         = 0 : static const Block
	ROCK          = 1 : static const Block
	WALL          = 2 : static const Block
	FLOOR         = 3 : static const Block
	PATH          = 4 : static const Block
	DOOR_CLOSED_H = 5 : static const Block
	DOOR_OPEN_H   = 6 : static const Block
	DOOR_CLOSED_V = 7 : static const Block
	DOOR_OPEN_V   = 8 : static const Block
	
	solids := static [ROCK, WALL, DOOR_CLOSED_H, DOOR_CLOSED_V] as ArrayList<Block>
	spawnables := static [FLOOR, PATH] as ArrayList<Block>
	doors := static [DOOR_CLOSED_H, DOOR_OPEN_H, DOOR_CLOSED_V, DOOR_OPEN_V] as ArrayList<Block>
		
	solid? : Bool {
		get { solids contains?(this) }
	}
	walkable? : Bool {
		get { !solids contains?(this) }
	}
	door? : Bool {
		get { doors contains?(this) }
	}
	spawnable? : Bool {
		get { spawnables contains?(this) }
	}
	opened? : Bool {
		get { this == DOOR_OPEN_V || this == DOOR_OPEN_H }
	}
	closed? : Bool {
		get { this == DOOR_CLOSED_V || this == DOOR_CLOSED_H }
	}
	open: func -> Block {
		match this {
			case DOOR_CLOSED_H => DOOR_OPEN_H
			case DOOR_CLOSED_V => DOOR_OPEN_V
			case => this
		}
	}
	close: func -> Block {
		match this {
			case DOOR_OPEN_H => DOOR_CLOSED_H
			case DOOR_OPEN_V => DOOR_CLOSED_V
			case => this
		}
	}
}

