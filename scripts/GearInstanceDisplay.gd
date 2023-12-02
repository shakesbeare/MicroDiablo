extends ColorRect

var gear
var readyCheck = false

@onready var nameLabel = get_node("dataContainer/NameLabel")
@onready var stat1Label = get_node("dataContainer/StatsContainer/Stat1Container/Stat1")
@onready var stat1DataLabel = get_node("dataContainer/StatsContainer/Stat1Container/Stat1Data")
@onready var stat2Label = get_node("dataContainer/StatsContainer/Stat2Container/Stat2")
@onready var stat2DataLabel = get_node("dataContainer/StatsContainer/Stat2Container/Stat2Data")

func _ready():
	readyCheck = true
	print("gear instance loaded")

func attachGear(attachedGear):
	gear = attachedGear
	if gear != null && readyCheck == true:
		updateDisplay()

func updateDisplay():
	nameLabel.text = gear.gearName
	stat1Label.text = gear.priStat
	stat1DataLabel.text = str(gear.priStatAmount)
	stat2Label.text = gear.secStat
	stat2DataLabel.text = str(gear.secStatAmount)
