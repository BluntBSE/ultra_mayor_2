class_name Services
extends Node

var card_service:CardService = null

func get_card_service()->CardService:
	return card_service

func register_service(service:Object)->void:
	if service is CardService:
		card_service = service
		pass
