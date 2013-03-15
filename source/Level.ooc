import math/Random
import structs/LinkedList
import vamos/[Engine, State]
import vamos/display/StateRenderer
import Map, Actor, Player, Controls, Generator
import mobs/Slime

Level: class extends State {
	
	map: Map
	actors := LinkedList<Actor> new()
	player: Player
	controls: Controls
	
	renderer: StateRenderer
	
	init: func {
		
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
		
		slime := Slime new() .setPos(20, 20)
		add(slime)
		
		controls = Controls new()
		add(controls)
	}
	
	add: func~actor (actor:Actor) {
		"adding actor '%s'" printfln(actor class name)
		actors add(actor)
		super(actor)
	}
	
	update: func (dt:Double) {
		super(dt)
		renderer camX = player x - renderer width/2
		renderer camY = player y - renderer height/2
		
		entities sort(|a, b| a y > b y)
	}
	
	turn: func {
		"updating the world" println()
		for (actor in actors) {
			actor takeTurn()
		}
	}
	
}