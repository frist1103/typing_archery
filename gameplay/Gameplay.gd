extends Node2D

var Enemy = preload("res://gameplay/Enemy.tscn")
export var Arrow = preload("res://gameplay/Arrow.tscn")

onready var player = $Player
onready var enemy_container = $EnemyContainer
onready var spawn_container = $SpawnContainer
onready var spawn_timer = $SpawnTimer
onready var game_timer = $GameTimer

onready var skill_value = $CanvasLayer/VBoxContainer/BottomRow/SkillCol/SkillRow/SkillValue
onready var killed_value = $CanvasLayer/VBoxContainer/BottomRow/KillCol/BottomRow/EnemyKillValue
onready var lv_value = $CanvasLayer/VBoxContainer/TopRow2/TopRow2/LvValue
onready var wave_value = $CanvasLayer/VBoxContainer/BottomRow/KillCol/BottomRow2/WaveValue
onready var game_over_screen = $CanvasLayer/GameoverScreen
onready var game_paused_screen = $CanvasLayer/GamePausedScreen
onready var game_time_value =$CanvasLayer/VBoxContainer/TopRow2/TopRow3/GameTimeValue
onready var esc_label = $CanvasLayer/VBoxContainer/TopRow2/TopRow4/EscLabel
onready var background = $BackGround

var active_enemy = null
var current_letter_index: int = -1





func _ready() -> void:
	start_game()

func _physics_process(delta):
	killed_value.text = str(PromptList.enemy_killed)
	skill_value.text = str(int(PromptList.skill_stk / 3))
	wave_value.text = str(PromptList.difficulty + 1)
	lv_value.text = "ด่าน : " + str(PromptList.lv) + "-" + str(PromptList.sub_lv)
	game_time_value.text =  "%02d:%02d" % [floor(PromptList.game_timer_value / 60), int(PromptList.game_timer_value) % 60]
	
	if PromptList.enemy_died == 10 and PromptList.difficulty < 2 :
		change_difficulyty()
		spawn_timer.start()
		PromptList.enemy_died = 0
	
	if PromptList.enemy_died == 10 and PromptList.difficulty == 2 :
#		โหลดฉากสรุปผล
		print("winner")
	
	if Input.is_action_just_released("use_skill") and PromptList.skill_stk >= 3:
		use_skill()
	
	if Input.is_action_pressed("ui_cancel"):
		esc_label.text = ""
		game_paused_screen.show()
		get_tree().paused = !get_tree().paused
		print(get_tree().paused)
		

func use_skill():
	GlobalSignals.emit_signal("use_skill")
	print("use skill")
	PromptList.skill_stk -= 3
	shooting_arrow_skil(Vector2(1 , 0))

#ฟังก์ชั่นค้นหาศัตรู
func find_new_active_enemy(typed_character: String):
	for enemy in enemy_container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(1,1)
		var typed_character_th = PromptList.tran_th(typed_character)
		if next_character == typed_character_th:
#		if next_character == typed_character:
			print("founed new enemy that starts with %s" %next_character)
			active_enemy = enemy
			current_letter_index = 2
			active_enemy.set_next_character(current_letter_index)
			return

#ฟังกชั่นสำหรับอีเว้นการกดปุ่ม
func _unhandled_input(event: InputEvent) -> void :
	
	if event is InputEventKey and event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
		var key_typed_th = PromptList.tran_th(key_typed)
		if active_enemy == null :
			find_new_active_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index,1)
			if key_typed_th == next_character:
				print("successfully typed %s" %key_typed_th)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				#	ถ้าพิมถูกครบแล้ว จะกำจัด
				if current_letter_index == prompt.length():
					print("done")
					active_enemy.alow_decreased()
					var arrow_direction = player.global_position.direction_to(active_enemy.global_position)
					shooting_arrow(arrow_direction)
					print(arrow_direction)
					active_enemy = null
					current_letter_index = -1
					
			else:
				print("incorrectly typed %s instead of %s" %[key_typed_th,next_character])
				active_enemy.false_key()
				active_enemy = null
				current_letter_index = -1


func shooting_arrow(arrow_direction: Vector2):
	var arrow = Arrow.instance()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = player.global_position
	
	var arrow_rotation = arrow_direction.angle()
	arrow.rotation = arrow_rotation

func shooting_arrow_skil(arrow_direction: Vector2):
	var arrow = Arrow.instance()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = player.global_position
	
	var arrow_rotation = arrow_direction.angle()
	arrow.rotation = arrow_rotation
	arrow.use_arrow_skill()


func _on_SpawnTimer_timeout():
	print( PromptList.difficulty)
	spawn_enemy()
	if PromptList.num_summon == 10 or PromptList.num_summon == 20 or PromptList.num_summon == 30 :
		spawn_timer.stop()

func spawn_enemy():
	
#	GlobalSignals.emit_signal("change_lv",lv)
	PromptList.num_summon += 1
	var enemy_instance = Enemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)
#	enemy_instance.set_difficulty(PromptList.difficulty)
	
#	print(PromptList.num_summon)
#	enemy.current_lv = 2

func change_difficulyty():
	PromptList.difficulty += 1
	GlobalSignals.emit_signal("difficulty_increased",PromptList.difficulty)
#	GlobalSignals.emit_signal("change_lv",lv)
	print("difficulty increased to %d" % PromptList.difficulty)
	var new_wait_timer = spawn_timer.wait_time - 1
	spawn_timer.wait_time = new_wait_timer
#	if difficulty >= 20:
#		PromptList.num_summon = 0
#		difficulty = 20
#		return
	

#	spawn_timer.wait_time = clamp(new_wait_timer, 1, spawn_timer.wait_time)

#func _on_DifficultyTimer_timeout():
#	difficulty += 1
#	GlobalSignals.emit_signal("difficulty_increased",difficulty)
##	GlobalSignals.emit_signal("change_lv",lv)
#	print("difficulty increased to %d" % difficulty)
#	var new_wait_timer = spawn_timer.wait_time - 0.2
#	spawn_timer.wait_time = clamp(new_wait_timer, 1, spawn_timer.wait_time)




func _on_LoseArea_body_entered(body):
	player.decreased_player_hp()
	active_enemy = null
	current_letter_index = -1
	if body.is_in_group("Boss") :
		player.damage_boss()
	if player.player_hp == 0 :
		game_over()
	


func game_over():
	game_over_screen.show()
	spawn_timer.stop()
	game_timer.stop()
	active_enemy = null
	current_letter_index = -1
	for enemy in enemy_container.get_children():
		enemy.queue_free()

func start_game():
	PromptList.num_summon = 0
	PromptList.difficulty = 0
	PromptList.enemy_killed = 0
	PromptList.skill_stk = 0
	PromptList.enemy_died = 0
	PromptList.enemy_boss = 0
	PromptList.game_timer_value = 0
	
	background.texture = load("res://assets/spaceshooter/Backgrounds/purple.png")
	
	player.re_hp()
	game_over_screen.hide()
	game_paused_screen.hide()
	lv_value.text = str(PromptList.difficulty)
	killed_value.text = str(PromptList.enemy_killed)
	var cal_timer: float = PromptList.lv + PromptList.sub_lv
	cal_timer = cal_timer * 0.1
	spawn_timer.wait_time = 7 - cal_timer
	print(spawn_timer.wait_time)
#	PromptList.lv = 2
	randomize()
	spawn_timer.start()
	game_timer.start()
	spawn_enemy()


func _on_RestartButtom_pressed():
	start_game()


func _on_GameTimer_timeout():
	PromptList.game_timer_value += 1




func _on_ContinueButtom_pressed():
	get_tree().paused = false
	game_paused_screen.hide()
	esc_label.text = "Esc : พักเกม"
#	print("yes")
