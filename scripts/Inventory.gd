extends Node

var gold
var adv1
var adv2
var adv3
var adv4
var advList = []
var gearList = []
var itemList = []

var gearDisplay = load("res://scenes/gear_instance.tscn")
var helm = load("res://InventoryItems/GearStuff/Helmet.gd")

@onready var gold_display = get_node("ColorRect/goldDisplay")
@onready var gearContainer = get_node("ColorRect/GearScrollContainer/GearVBox")

func _ready():
	gold = 0
	updateGoldCounter()

func _init():
	pass

func getGear():
	pass

func addGear(newGear):
	gearList.append(newGear)

func getItems():
	pass

func addItem(newItem):
	itemList.append(newItem)

func getAdventurerList():
	return advList

func getActiveAdventurers():
	var advReturn = [adv1, adv2, adv3, adv4]
	return advReturn

func addAdventurer(newAdv):
	advList.append(newAdv)

func getGold():
	return gold

func addGold(amt):
	gold += amt
	updateGoldCounter()

func spendGold(amt):
	if gold < amt:
		return false
	else:
		gold -= amt
		updateGoldCounter()
		return true

func updateGoldCounter():
	gold_display.text = str(gold)

func _on_button_pressed():
	gold += 1
	updateGoldCounter()


func _on_spend_gold_button_pressed():
	spendGold(15)


func _on_generate_gear_button_pressed():
	var newGear = gearDisplay.instantiate()
	var testHelm = helm.new()
	await newGear._ready()
	print("received load signal")
	newGear.attachGear(testHelm)
	gearContainer.add_child(newGear)
