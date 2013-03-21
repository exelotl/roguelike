import math/Random
import structs/LinkedList
import vamos/[Engine, State]
import vamos/display/StateRenderer
import Map, Log, Actor, Player, Controls, Generator, Darkness, Spawner

Level: class extends State {
	
	map: Map
	darkness: Darkness
	log: Log
	actors := LinkedList<Actor> new()
	player: Player
	controls: Controls
	spawner: Spawner
	animTime: Double
	animating? : Bool {
		get { animTime >= 0 }
	}
	renderer: StateRenderer
	
	init: func {
		onEntityAdded add(|e|
			if (e instanceOf?(Actor)) {
				actors add(e as Actor)
				"adding actor '%s'" printfln(e class name)
				darkness update()
			}
		)
		onEntityRemoved add(|e|
			if (e instanceOf?(Actor)) {
				a := e as Actor
				actors remove(a)
				map unsetFlag(a mapX, a mapY, BlockFlag OCCUPIED)
				"removing actor '%s'" printfln(e class name)
			}
		)
	}
	
	create: func {
		renderer = engine stateRenderer
		
		map = Map new(60, 60)
		add(map)
		generator := Generator new(map)
		generator generate()
		
		player = Player new()
		player setPos(30, 30)
		add(player)
		
		controls = Controls new()
		add(controls)
		
		spawner = Spawner new(this)
		
		darkness = Darkness new(this)
		add(darkness)
	}
	
	getBrightness: func (x, y:Int) -> UInt {
		darkness get(x, y)
	}
	
	update: func (dt:Double) {
		super(dt)
		renderer camX = player x - renderer width/2
		renderer camY = player y - renderer height/2
		
		entities sort(|a, b| a y > b y)
		entities remove(darkness)
		entities add(darkness)
		
		if (animating?)
			animTime -= dt
	}
	
	turn: func {
		spawner update()
		for (actor in actors) {
			actor takeTurn()
		}
		darkness update()
		animTime += 0.16
	}
	
	getActor: func (x, y:Int) -> Actor {
		for (actor in actors)
			if (actor mapX == x && actor mapY == y)
				return actor
		null
	}
	
}