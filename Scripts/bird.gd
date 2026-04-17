extends Sprite2D

var vel: Vector2 = Vector2(0,0)

func _process(delta: float) -> void:
	vel = lerp(vel, (get_global_mouse_position() - global_position) * 5.0, delta)
	vel -= vel.normalized() * delta * 0.1
	translate(vel * delta)
	
	if (get_global_mouse_position() - global_position).x > 0:
		flip_v = false
	else:
		flip_v = true
	
	look_at(get_global_mouse_position())
