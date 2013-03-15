import structs/ArrayList
import vamos/[Entity, Util]
import vamos/graphics/TileMap
import main

Map: class extends Entity {
	
	data: Block*
	w, h: UInt // size in tiles
	
	tilemap: TileMap
	
	init: func (=w, =h) {
		data = gc_malloc(w * h * UInt size) as Block*
		
		tilemap = TileMap new("tiles.png", w, h, TILE_W, TILE_H)
		tilemap data = data
		graphic = tilemap
		clear(Block ROCK)
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
				}
				y += sy
			}
		}
		set(x, y, val)
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
		
	clear: func (val:Block) {
		for (x in 0..w)
			for (y in 0..h)
				set(x, y, val)
	}
}

Block: cover from UInt {
	
	EMPTY = 0 : static const Block
	ROCK  = 1 : static const Block
	WALL  = 2 : static const Block
	FLOOR = 3 : static const Block
	PATH  = 4 : static const Block
	DOOR  = 5 : static const Block
	
	solids := static [ROCK, WALL] as ArrayList<Block>
		
	solid? : Bool {
		get { solids contains?(this) }
	}
}

