extends Node
class_name PlayerInPlay

var in_play:Array = []


func handle_played(stub:PlayerCardStub)->void:
	#Although the emission occurs from a RenderedCard, we actually receive the stub representing the played card.
	in_play.push_back(stub) #Maybe do push front?
	organize_stubs()

func handle_resolved(stub:PlayerCardStub)->void:
	in_play.erase(stub)

func organize_stubs() -> void:
	var HARD_MAX: float = 700.0 #Max width. Over this, cards might overlap.
	var num_in_play:int = in_play.size()
	if num_in_play == 0:
		return

	var idx:int = 0
	for stub:PlayerCardStub in in_play:
		var destination:Vector2 = self.global_position + Vector2(250.0*(idx),0.0)
		var dest_args:Dictionary = {
			"global_position":destination,
			"scale": Vector2(1.0,1.0),
			"rotation": 0.0,
			"time": 0.25,
			"fin_z": idx,
			"final_state": "inspectable"
		}
		stub.do_transit(dest_args)
		idx += 1
