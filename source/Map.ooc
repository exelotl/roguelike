import vamos/Entity
import vamos/graphics/TileMap

Map: class extends Entity {
	
	data: UInt*
	w, h: UInt // size in tiles
	
	tilemap: TileMap
	
	init: func (=w, =h) {
		data = gc_malloc(w * h * UInt size) as Int*
		
		tilemap = TileMap new("tiles.png", w, h, 24, 18)
		tilemap data = data
		graphic = tilemap
		clear(2)
	}
	
	get: inline func(x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : 0
	}
	set: inline func(x, y, val:UInt) {
		if (x < w && y < h)
			data[x + y*w] = val
	}
	
	clear: func (val:UInt) {
		for (x in 0..w)
			for (y in 0..h)
				set(x, y, val)
	}
}

extend UInt {
	isWall: func -> Bool {
		this == 1
	}
}