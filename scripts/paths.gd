class_name Paths
extends Node

var Pathfinding = preload("res://scripts/cs/Pathfinding.cs")
static var pathfinding


func _init():
	pathfinding = Pathfinding.new()
	pathfinding.Setup(Graphics.GROUND_SIZE)
