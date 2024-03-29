extends Resource
class_name Event

@export var id: int
@export var name: String

@export var description: String

@export var random_event: bool = true
@export var event_seen: bool = false

@export var good: bool # Used for dynamic music purposes
@export var bad: bool

@export var choice_list: Array[Choice] = []
