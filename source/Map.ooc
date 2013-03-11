import vamos/Entity
import vamos/graphics/TileMap

Map: class extends Entity {
	
	data: Int*
	width, height: Int
	
	init: func (=width, =height) {
		data = gc_malloc(width * height * Int size) as Int*
	}
	
	getState: func (x, y:Int) -> Int {
		data[x + y*height]
	}
	setState: func (x, y, val:Int) -> Int {
		data[x + y*height] = val
	}
	
}
