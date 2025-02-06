extends Node
class_name PlayerState

var action_points:int:
    get:
        return action_points
    set(value):
        action_points = value
        ap_updated.emit(action_points)
        
var techs:Dictionary:
    get:
        return techs

var extant_pilots:Array = [] #LogicalPilots.
#Hangar object = {"hangar": "hangar_public_works", 
var hangars:Array = []#Updated when an appropriate building is placed

signal ap_updated
signal techs_updated
signal hangars_modified

func _ready()->void:
    action_points = 40


func initialize_new()->void:
    action_points = 50

func process_placed_building(command:BuildingCommand)->void:
    #TODO: Fulfil campaign promises, or not
    action_points -= command.building.ap_cost
    pass

func append_hangar(hangar:Hangar)->void:
    hangars.append(hangar)
    hangars_modified.emit(hangars)
    
func erase_hangar(hangar:Hangar)->void:
    for h:Hangar in hangars:
        if h.id == hangar.id:
            hangars.erase(h)
    hangars_modified.emit(hangars)
