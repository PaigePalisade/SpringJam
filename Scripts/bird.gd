class_name Bird

extends Sprite2D


@onready var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
@export var health: int = 75

var vel: Vector2 = Vector2(0,0)
var bullet_timer: float = 0.0

func _process(delta: float) -> void:
	bullet_timer -= delta
	vel = lerp(vel, (get_global_mouse_position() - global_position) * 5.0, delta)
	vel -= vel.normalized() * delta * 0.1
	translate(vel * delta)
	
	if (get_global_mouse_position() - global_position).x > 0:
		flip_v = false
	else:
		flip_v = true
	
	if global_position.x < 0:
		global_position.x = 0
		vel.x = 0
	
	if global_position.x > get_viewport_rect().size.x:
		global_position.x = get_viewport_rect().size.x
		vel.x = 0
		
	if global_position.y < 0:
		global_position.y = 0
		vel.y = 0
	
	if global_position.y > get_viewport_rect().size.y:
		global_position.y = get_viewport_rect().size.y
		vel.y = 0
	
	look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and bullet_timer < 0:
		var bullet_vel: Vector2 = vel + Vector2(1,0).rotated(rotation) * 500.0
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.vel = bullet_vel
		get_parent().add_child(bullet)
		bullet.rotation = bullet.vel.angle()
		bullet.global_position = global_position + bullet.vel.normalized() * 20
		bullet_timer = 0.1
		
