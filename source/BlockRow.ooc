import vamos/Entity
import vamos/graphics/TileMap
import main

// Displays a row of wall blocks. These can then be sorted by depth
BlockRow: class extends Entity {
	
	init: func (data:UInt*, mapY, width:UInt) {
		y = mapY*TILE_H - 30 + TILE_H
		tiles := TileMap new("wall_blocks.png", width, 1, 24, 30)
		tiles data = data[mapY*width]&
		graphic = tiles
	}
	
}