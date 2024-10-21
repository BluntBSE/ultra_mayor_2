@tool
"""
extends Node2D

func _process(_delta:float)->void:

	connector_left.position = line.points[0]

	connector_left.rotation = line.points[0].angle_to_point(line.points[1])

	connector_right.position = line.points[1]

	connector_right.rotation = line.points[0].angle_to_point(line.points[1])
"""
