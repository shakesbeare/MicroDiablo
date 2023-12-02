extends Node

var atkName
var atkID
var dmgType
var dmgScalar
var castTime
var range
var area
var level
var currentXP
var totalXP

func addXP(add):
	currentXP += add
	checkLevel()

func checkLevel():
	if currentXP >= totalXP:
		level += 1
		currentXP -= totalXP
		totalXP = totalXP*1.5


