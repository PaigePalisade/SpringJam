class_name HomingBird

extends Sprite2D

var spawned = false

var health: int = 100
var is_hit: bool = false

@export var default_timer: float = 12.0
@onready var bullet_scene: PackedScene = preload("res://Scenes/bullet.tscn")
@onready var explosion_texture = preload("res://Sprites/explosion.png")
@onready var default_texture = texture
@onready var timer = default_timer

var vel: Vector2
var bullet_timer: float = 0.0
var explosion_timer: float = -1.0

enum State {DEAD, SHOOTING, HOMING, RESTING, GAME_OVER}

var state: State = State.GAME_OVER

func _process(delta: float) -> void:
	health = max(health, 0)
	timer -= delta
	
	if timer < 10.0 and timer > 5.0:
		state = State.SHOOTING
	if timer < 5.0:
		state = State.HOMING
	if (timer < 0.0 or health == 0 or is_hit) and not (state == State.RESTING or state == State.GAME_OVER):
		state = State.DEAD
		if health == 0:
			GlobalState.score += 100
		$"../Bird".health = min(100, $"../Bird".health + 5)
	if GlobalState.game_over:
		state = State.RESTING
	
	if state == State.GAME_OVER and not GlobalState.game_over:
		state = State.RESTING
		timer = default_timer
		print(timer)
	
	if state == State.SHOOTING:
		if not spawned:
			global_position = GlobalState.player_pos
			while (global_position - GlobalState.player_pos).length() < 200.0:
				global_position = Vector2(
					randf() * get_viewport_rect().size.x,
					randf() * get_viewport_rect().size.y
				)
			spawned = true
			show()
		var target_rotation: float = (get_node("../Bird").global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_rotation, delta * 4.0)
		vel = Vector2.ZERO
		if bullet_timer < 0:
			var bullet_vel: Vector2 = vel + Vector2(1,0).rotated(rotation) * 500.0
			var bullet: Bullet = bullet_scene.instantiate()
			bullet.vel = bullet_vel
			bullet.is_evil = true
			get_parent().add_child(bullet)
			bullet.rotation = bullet.vel.angle()
			bullet.global_position = global_position + bullet.vel.normalized() * 20
			bullet_timer = 0.2
		bullet_timer -= delta
		
	elif state == State.HOMING:
		vel = lerp(vel, Vector2(1,0).rotated(rotation) * delta * 1000.0, delta)
		var target_rotation: float = (get_node("../Bird").global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_rotation, delta * 2.0)
		translate(Vector2(1,0).rotated(rotation) * delta * 500.0)
		
	if state == State.DEAD:
		timer = 12.0
		state = State.RESTING
		explosion_timer = 0.2
		is_hit = false
	
	if explosion_timer > 0.0:
		explosion_timer -= delta
		texture = explosion_texture
	elif state == State.RESTING or state == State.GAME_OVER:
		texture = default_texture
		spawned = false
		hide()
		global_position = Vector2(-100,-100)
		health = 100
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj is Bullet and not obj.is_evil:
		health -= 40
		obj.queue_free()
		GlobalState.score += 10


func _on_menu_reset() -> void:
	timer = default_timer
