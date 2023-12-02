extends Node

var parent_Adventurer

var health
var mana
var manaRegen
var physAttack
var magicAttack
var holyAttack
var dodge
var physDefense
var magicDefense



func _init(p):
	parent_Adventurer = p

func getAllStats():
	var allStats = [health, mana, manaRegen, physAttack, magicAttack, holyAttack, dodge, physDefense, magicDefense]
	return allStats

func recalcStats():
	pass

func scaleToLevel():
	pass

