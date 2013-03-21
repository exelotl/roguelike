import structs/LinkedList
import vamos/Entity
import vamos/graphics/SpriteFont
import Actor

Log: class extends Entity {
	
	capacity := 100
	messages := LinkedList<LogMsg> new()
	text := SpriteFont new("font.png", 8, 8)
	
	init: func {
		graphic = text	
	}
	
	write: func (text:String) {
		if (messages size >= capacity)
			messages removeAt(0)
		messages add(LogMsg new(text))
		this text = text
	}
	
}

LogMsg: class {
	text: String
	init: func (=text)
	init: func ~action (action:Action) {
		init(action getMessage())
	}
}

extend Action {
	getMessage: func -> String {
		
		return match type {
			case ActionType OPEN => successful ? "You open the door" : "The door is jammed."
			case ActionType ATTACK => successful ? "You hit the "+target type+"." : "You miss the "+target type+"."
			case => null
		}
	}
}