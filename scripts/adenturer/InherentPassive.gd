extends "res://AdventurerScripts/Passive.gd"

var statsBoosted = []

func _init():
	statsBoosted = [["attack", 5], ["health", 10]]
	print(statsBoosted)
	print(statsBoosted[0][0] + str(statsBoosted[0][1]) + statsBoosted[1][0] + str(statsBoosted[1][1]))

func calcBoosts():
	pass

