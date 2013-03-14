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
	}
	
	get: func (x, y:UInt) -> UInt {
		data[x + y*h]
	}
	set: func (x, y, val:UInt) {
		data[x + y*h] = val
	}
	
}

extend UInt {
	isWall: func -> Bool {
		this == 0
	}
}