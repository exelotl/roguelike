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
	
	drawLine: func (x0, y0, x1, y1:UInt, val:Block) {
		if (x0 > x1) (x0, x1) = (x1, x0)
		if (y0 > y1) (y0, y1) = (y1, y0)
		dx := (x1 - x0) abs()
		dy := (y1 - y0) abs()
		sx := x0 < x1 ? 1 : -1
		sy := y0 < y1 ? 1 : -1
		err := dx - dy
		while (true) {
			set(x0, y0, val)
			if (x0 == x1 && y0 == y1) break
			e2 := 2 * err
			if (e2 > -dx) {
				err -= dy
				x0 += sx
			}
			if (e2 < dx) {
				err += dx
				y0 += sy
			}
		}
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

