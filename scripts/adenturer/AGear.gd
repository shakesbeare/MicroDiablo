extends Node

var parent_Adventurer

var eqHelm
var eqChest
var eqGloves
var eqLegs
var eqBoots
var eqWeapon
var eqOffhand
var eqNeck
var eqRing
var eqGearList = []

func _init(p):
	parent_Adventurer = p

func equipGear(newGear):
	match newGear.gearType:
		"helm":
			if eqHelm != null:
				eqGearList.erase(eqHelm)
			eqHelm = newGear
		"chest":
			if eqChest != null:
				eqGearList.erase(eqChest)
			eqChest = newGear
		"gloves":
			if eqGloves != null:
				eqGearList.erase(eqGloves)
			eqGloves = newGear
		"legs":
			if eqLegs != null:
				eqGearList.erase(eqLegs)
			eqLegs = newGear
		"boots":
			if eqBoots != null:
				eqGearList.erase(eqBoots)
			eqBoots = newGear
		"weapon":
			if eqWeapon != null:
				eqGearList.erase(eqWeapon)
			eqWeapon = newGear
		"offhand":
			if eqOffhand != null:
				eqGearList.erase(eqOffhand)
			eqOffhand = newGear
		"necklace":
			if eqNeck != null:
				eqGearList.erase(eqNeck)
			eqNeck = newGear
		"ring":
			if eqRing != null:
				eqGearList.erase(eqRing)
			eqRing = newGear
	eqGearList.append(newGear)

func unequipGear(oldGear):
	match oldGear.gearType:
		"helm":
			if eqHelm != null:
				eqGearList.erase(eqHelm)
			eqHelm = null
		"chest":
			if eqChest != null:
				eqGearList.erase(eqChest)
			eqChest = null
		"gloves":
			if eqGloves != null:
				eqGearList.erase(eqGloves)
			eqGloves = null
		"legs":
			if eqLegs != null:
				eqGearList.erase(eqLegs)
			eqLegs = null
		"boots":
			if eqBoots != null:
				eqGearList.erase(eqBoots)
			eqBoots = null
		"weapon":
			if eqWeapon != null:
				eqGearList.erase(eqWeapon)
			eqWeapon = null
		"offhand":
			if eqOffhand != null:
				eqGearList.erase(eqOffhand)
			eqOffhand = null
		"necklace":
			if eqNeck != null:
				eqGearList.erase(eqNeck)
			eqNeck = null
		"ring":
			if eqRing != null:
				eqGearList.erase(eqRing)
			eqRing = null
