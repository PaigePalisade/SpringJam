class_name HomingBird

extends Sprite2D

var timer: float = 12.0
var spawned = false

@export var health: int = 100

var vel: Vector2

func _process(delta: float) -> void:
	timer -= delta
	
	if timer < 10.0 and timer > 5.0:
		if not spawned:
			global_position = Vector2(
				randf() * get_viewport_rect().size.x,
				randf() * get_viewport_rect().size.y
			)
			spawned = true
			show()
		look_at(get_node("../Bird").global_position)
		vel = Vector2.ZERO
	elif timer < 5.0:
		vel = lerp(vel, Vector2(1,0).rotated(rotation) * delta * 1000.0, delta)
		var target_rotation: float = (get_node("../Bird").global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_rotation, delta * 2.0)
		translate(Vector2(1,0).rotated(rotation) * delta * 500.0)
	if timer < 0.0 or health == 0:
		timer = 12.0
		spawned = false
		health = 100
		global_position = Vector2(-100,-100)
		hide()
		
	if (get_global_mouse_position() - global_position).x > 0:
		flip_v = false
	else:
		flip_v = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj is Bullet:
		health -= 10
		obj.queue_free()
