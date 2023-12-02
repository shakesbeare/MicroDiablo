extends Node

var parent_Adventurer

var atk1
var atk2
var atk3
var atk4

func _init(p):
	parent_Adventurer = p

func getAllAttacks():
	var atkList = [atk1, atk2, atk3, atk4]
	return atkList

func equipAttack(slot, atk):
	match slot:
		1:
			atk1 = atk
		2:
			atk2 = atk
		3:
			atk3 = atk
		4:
			atk4 = atk

func castAttack(which):
	match which:
		1:
			var returnData = [atk1.dmgType, atk1.dmgScalar, atk1.castTime, atk1.range, atk1.area]
			return returnData
		2:
			var returnData = [atk2.dmgType, atk2.dmgScalar, atk2.castTime, atk2.range, atk2.area]
			return returnData
		3:
			var returnData = [atk3.dmgType, atk3.dmgScalar, atk3.castTime, atk3.range, atk3.area]
			return returnData
		4:
			var returnData = [atk4.dmgType, atk4.dmgScalar, atk4.castTime, atk4.range, atk4.area]
			return returnData
		

