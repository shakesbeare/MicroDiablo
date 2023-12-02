extends "res://InventoryItems/GearStuff/Gear.gd"



func _init():
	gearType = "helm"
	gearName = "leather helm"
	priStat = "physDefense"
	priStatAmount = 5
	secStat = "dodge"
	secStatAmount = 10
	print(gearType + " " + gearName + " " + priStat)



