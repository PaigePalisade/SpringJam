class_name HealthBar

extends Node

@onready var bg: Polygon2D = $bg
@onready var fg: Polygon2D = $bg/fg
var parent: Node2D

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	bg.global_position = parent.global_position + Vector2(-12, 20)
	fg.scale.x = max(parent.health / 100.0, 0.0)
