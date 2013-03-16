import math/Random
import structs/ArrayList
import vamos/[Entity, Util]
import vamos/graphics/TileMap
import main, Level, Map, Actor

// Tilemap of brightness levels
// Higher values represent lighter areas
// 1 = completely black
// 20 = fully lit

Darkness: class extends Entity {
	
	MAX_LIGHT: static const UInt = 20
	
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
	
	update: func~step {
		clear(data)
		for (a in actors) {
			add(data, a mapX, a mapY, a brightness)
		}
		for (i in 0..20)
			generate()
		smooth()
		smooth()
		smooth()
		tiles data = data
	}
	
	generate: func {
		clear(buffer)
		for (x in 1..w-1) {
			for (y in 1..h-1) {
				o:Int = get(x, y)
				n := o
				n = max(n, get(x+1, y+1))
				n = max(n, get(x,   y+1))
				n = max(n, get(x-1, y+1))
				n = max(n, get(x+1, y))
				n = max(n, get(x-1, y))
				n = max(n, get(x+1, y-1))
				n = max(n, get(x,   y-1))
				n = max(n, get(x-1, y-1))
				block := map get(x, y)
				if (block solid?) n = 0
				if (block == Block PATH) n -= 5
				set(buffer, x, y, max(n,o))
			}
		}
		(data, buffer) = (buffer, data)
	}
	
	smooth: func {
		for (x in 1..w-1) {
			for (y in 1..h-1) {
				o := get(x, y)
				n := get(x+1, y) +
				     get(x-1, y) +
				     get(x, y+1) +
				     get(x, y-1)
				n /= 4
				set(buffer, x, y, max(n, o))
			}
		}
		(data, buffer) = (buffer, data)
	}
	
	get: inline func(x, y:UInt) -> UInt {
		data[x + y*w]
	}
	set: inline func(arr:UInt*, x, y:UInt, val:Int) {
		arr[x + y*w] = val clamp(1, MAX_LIGHT)
	}
	add: inline func(arr:UInt*, x, y:UInt, val:Int) {
		arr[x + y*w] = (arr[x + y*w] + val) clamp(1, MAX_LIGHT)
	}
	
	clear: func (arr:UInt*) {
		for (x in 0..w)
			for (y in 0..h)
				set(arr, x, y, 1)
	}
	
}