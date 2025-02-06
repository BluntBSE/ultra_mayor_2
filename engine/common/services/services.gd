class_name Services
extends Node

var card_service:CardService = null
var sound_service:SoundService = null

func get_card_service()->CardService:
    return card_service

func get_sound_service()->SoundService:
    return sound_service

func register_service(service:Object)->void:
    if service is CardService:
        print("Registered card service!")
        card_service = service
    if service is SoundService:
        print("Registered sound service!")
        sound_service = service


func _ready()->void:
    register_service(CardService.new())
    #Sound service is a node that registers itself

func _process(delta:float)->void:
    pass
