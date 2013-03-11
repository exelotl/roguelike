use vamos
import vamos/Engine
import Level

main: func(argc:Int, argv:CString*) {
	
	level := Level new()
	
	engine := Engine new(600, 600, 60)
	engine caption = "roguelike"
	engine start(level)
}