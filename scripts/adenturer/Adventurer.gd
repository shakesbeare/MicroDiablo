extends Node

var AGear = load("res://AdventurerScripts/AGear.gd")
var AStats = load("res://AdventurerScripts/AStats.gd")
var APassives = load("res://AdventurerScripts/APassives.gd")
var AAttacks = load("res://AdventurerScripts/AAttacks.gd")

var adventurerName
var adventurerID
var role
var level
var experience
var XPRequired
var partyPosition
var unlockedAtacks
var unlockedPassives
var gear
var stats
var passives
var attacks


func _ready():
	role = "Knight"
	level = 1
	adventurerName = "Arthur"
	adventurerID = 1000
	
	gear = AGear.new(self)
	stats = AStats.new(self)
	passives = APassives.new(self)
	attacks = AAttacks.new(self)
	
	
	


func AddToParty(pos):
	partyPosition = pos
	return true

func RemoveFromParty():
	partyPosition = 0
	return true

func ChangeClass(newRole):
	
	role = newRole
	return true

func addXP(xp):
	experience+=xp

func checkLevel():
	if experience >= XPRequired:
		level += 1
		experience -= XPRequired
		XPRequired = XPRequired*1.5

func update():
	stats.recalcStats()


