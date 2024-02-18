extends Resource
class_name Choice

enum Upgrade {
	blank,
	snailRepellant,
	waterproofCoating,
	kingsSigil,
	railLayingMachine,
	medicalCar,
	highMorale
}

@export var next_event_id: int = -1
@export var text: String
@export var effect_list: Array[GlobalDataSingle.Effect]

@export var result_text: String = ""

@export var upgrade: Upgrade = Upgrade.blank
@export var requires_upgrade: bool = false
