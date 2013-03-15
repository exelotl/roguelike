use vamos
import vamos/Engine
import Level

// constants
TILE_W := const 24
TILE_H := const 18

main: func(argc:Int, argv:CString*) {
	
	level := Level new()
	
	engine := Engine new(600, 600, 60)
	engine caption = "roguelike"
	engine start(level)
}