extends Node

var eqInherentPassives = []
var eqAuraPassives = []
var eqEffectPassives = []
var parent_Adventurer

var testPassive = load("res://AdventurerScripts/InherentPassive.gd")

func _init(p):
	parent_Adventurer = p
	var passive1 = testPassive.new()

func equipPassive(newPassive):
	match newPassive.type:
		1:
			eqInherentPassives.append(newPassive)
		2:
			eqEffectPassives.append(newPassive)
		3:
			eqAuraPassives.append(newPassive)

func unequipPassive(oldPassive):
	match oldPassive.type:
		1:
			eqInherentPassives.erase(oldPassive)
		2:
			eqEffectPassives.erase(oldPassive)
		3:
			eqAuraPassives.erase(oldPassive)

