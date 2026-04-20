class_name Bullet

extends Sprite2D

var vel: Vector2
var is_evil: bool = false
@onready var evil_texture = preload("res://Sprites/evilbullet.png")

var life: float

func _ready() -> void:
	life = 5.0

func _process(delta: float) -> void:
	if not GlobalState.game_over:
		if is_evil:
			texture = evil_texture
		translate(vel * delta)
		life -= delta
		
		if vel.length() < 500.0:
			vel += vel.normalized() * delta * 500.0
		
		if global_position.x < -100 or \
			global_position.y < -100 or \
			global_position.x > get_viewport_rect().size.x + 100 or \
			global_position.y > get_viewport_rect().size.y + 100 or \
			life < 0:
				queue_free()
	else:
		queue_free()
