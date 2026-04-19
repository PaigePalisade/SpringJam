class_name Bird

extends Sprite2D


@onready var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
@onready var default_texture = texture
@onready var explosion_texture = preload("res://Sprites/explosion.png")
var health: int = 100

var vel: Vector2 = Vector2(0,0)
var bullet_timer: float = 0.0

var explosion_timer = -1.0

func _process(delta: float) -> void:
	if GlobalState.game_over:
		position = Vector2(-100,-100)
	elif explosion_timer < 0.0:
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
		
#		so that the homing_birds know where not to spawn
		GlobalState.player_pos = global_position
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and bullet_timer < 0:
			var bullet_vel: Vector2 = vel + Vector2(1,0).rotated(rotation) * 800.0
			var bullet: Bullet = bullet_scene.instantiate()
			bullet.vel = bullet_vel
			get_parent().add_child(bullet)
			bullet.rotation = bullet.vel.angle()
			bullet.global_position = global_position + bullet.vel.normalized() * 20
			bullet_timer = 0.05

		if health <= 0:
			explosion_timer = 0.2
	else:
		texture = explosion_texture
		explosion_timer -= delta
		if explosion_timer < 0.0:
			GlobalState.game_over = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj is HomingBird and obj.state != HomingBird.State.RESTING:
		obj.is_hit = true
		health -= 10
	if obj is Bullet and obj.is_evil:
		health -= 5
		obj.queue_free()


func _on_menu_reset() -> void:
	health = 100
	texture = default_texture
