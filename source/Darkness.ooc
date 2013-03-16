import math/Random
import structs/ArrayList
import vamos/[Entity, Util]
import vamos/graphics/TileMap
import main, Level, Map, Actor

// Tilemap of brightness levels
// Higher values represent darker areas
// 0 = fully lit
// 20 = completely black

Darkness: class extends Entity {
	
	MAX_DARKNESS: static const UInt = 20
		
	data: UInt*
	buffer: UInt*
	w, h: UInt
	level: Level
	map: Map
	actors: ArrayList<Actor>
	tiles: TileMap
	
	init: func (=level) {
		actors = level actors
		map = level map
		w = map w
		h = map h
		data = gc_malloc(w * h * UInt size)
		buffer = gc_malloc(w * h * UInt size)
		tiles = TileMap new("darkness.png", w, h, TILE_W, TILE_H)
		tiles data = data
		graphic = tiles
	}
	
	step: func {
		clear(data)
		for (a in actors)
			set(data, a mapX, a mapY, (MAX_DARKNESS-a brightness) clamp(0, MAX_DARKNESS))
		for (i in 0..10)
			generate()
		tiles data = data
	}
	
	generate: func {
		clear(buffer)
		for (x in 0..w) {
			for (y in 0..h) {
				
				block := map get(x, y)
				dark := get(data, x, y)
				a := 1.0/(dark as Double) * MAX_DARKNESS
				if (block solid?)
					a /= 2
				
				if (dark < MAX_DARKNESS) {
					light(buffer, x+1, y, a)
					light(buffer, x-1, y, a)
					light(buffer, x, y+1, a)
					light(buffer, x, y-1, a)
					light(buffer, x+1, y+1, a)
					light(buffer, x+1, y-1, a)
					light(buffer, x-1, y+1, a)
					light(buffer, x-1, y-1, a)
				}
			}
		}
		(data, buffer) = (buffer, data)
	}
	
	get: inline func(arr:UInt*, x, y:UInt) -> UInt {
		arr[x + y*w]
	}
	set: inline func(arr:UInt*, x, y, val:UInt) {
		arr[x + y*w] = val
	}
	light: inline func(arr:UInt*, x, y, val:UInt) {
		arr[x + y*w] = (arr[x + y*w] - val) clamp(0, MAX_DARKNESS)
	}
	
	clear: func (arr:UInt*) {
		for (x in 0..w)
			for (y in 0..h)
				set(arr, x, y, MAX_DARKNESS)
	}
	
}