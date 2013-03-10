use vamos
import vamos/Engine
import PlayState

main: func(argc:Int, argv:CString*) {
	
	playstate := PlayState new()
	
	engine := Engine new(600, 600, 60)
	engine caption = "roguelike"
	engine start(playstate)
}