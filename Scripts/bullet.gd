class_name Bullet

extends Sprite2D

@export var vel: Vector2

var life: float

func _ready() -> void:
	life = 5.0

func _process(delta: float) -> void:
	translate(vel * delta)
	life -= delta
	
	if vel.length() < 500.0:
		vel += vel.normalized() * delta * 500.0
	
	if global_position.x < 0 or \
		global_position.y < 0 or \
		global_position.x > get_viewport_rect().size.x or \
		global_position.y > get_viewport_rect().size.y or \
		life < 0:
			queue_free()
