extends KinematicBody2D

var arrow = preload ("res://gameplay/Arrow.tscn")

export (Color) var blue = Color("#4682b4")
export (Color) var green = Color("#00ff00")
export (Color) var darkgreen = Color("#32cd32")
export (Color) var red = Color("#ff0000")
export (Color) var gray = Color("#d3d3d3")

export (float) var speed = 0.4

onready var enemy_hp_label = $Label
onready var prompt = $RichTextLabel
onready var prompt_text = prompt.text
onready var sprite = $Node2D

export var current_lv = 0
export var current_sub_lv = 0
var current_enemy_hp = 0
var alow = false

func _ready() -> void :
	current_lv = PromptList.lv
	current_sub_lv = PromptList.sub_lv
	current_enemy_hp = PromptList.get_enemy_hp(PromptList.difficulty)
	set_ready()
	random_sprite(current_lv)
	GlobalSignals.connect("difficulty_increased", self, "handle_difficulty_increased")
	GlobalSignals.connect("use_skill",self,"use_skill")
	if PromptList.enemy_boss == 0 and PromptList.difficulty == 0 :
		be_boss()
#		print(sprite.scale)


func set_ready() -> void :
	prompt_text = PromptList.get_prompt(current_lv)
	prompt.parse_bbcode(set_center_tags(prompt_text))
	alow = false

func false_key() -> void :
	prompt.parse_bbcode(set_center_tags(prompt_text))
	alow = false

func _physics_process(delta: float) -> void:
	global_position.x -= speed
	enemy_hp_label.text = str(current_enemy_hp)
	if current_enemy_hp == 0:
		PromptList.enemy_killed += 1
		PromptList.skill_stk += 1
		PromptList.enemy_died += 1
		queue_free()

func random_sprite(current_lv : int):
	var randsprite:int = rand_range(1 , 5)
	if current_lv == 1 :
		sprite.texture = load("res://assets/spaceshooter/PNG/Enemies/enemyBlue" + str(randsprite) + ".png")
#		print("res://assets/spaceshooter/PNG/Enemies/enemyBlue" + str(randsprite) + ".png")
	if current_lv == 2 :
		sprite.texture = load("res://assets/spaceshooter/PNG/Enemies/enemyGreen" + str(randsprite) + ".png")

#func set_difficulty(difficulty: int):
#	handle_difficulty_increased(difficulty)
#
#func handle_difficulty_increased(new_difficulty: int):
##	var new_speed = speed + (0.125 * new_difficulty)
##	speed = clamp(new_speed, speed, 2)
#	pass

func get_prompt() -> String:
	return prompt_text

func get_enemy_hp() :
	return current_enemy_hp

func decreased_enemy_hp():
	current_enemy_hp -= 1

func use_skill():
	decreased_enemy_hp()
	set_ready()

func alow_decreased():
	alow = true
	$Area2D.add_to_group("enemy")
	$CollisionShape2D.add_to_group("enemy")

func be_boss():
	self.add_to_group("Boss")
	current_enemy_hp = PromptList.get_enemy_hp(PromptList.difficulty) + 20
	speed = 0.2
	PromptList.enemy_boss = 1
	sprite.scale = Vector2(1.5,1.5)
	enemy_hp_label.margin_left = 70
	enemy_hp_label.margin_right = 110
	prompt.margin_top = 45
	prompt.margin_bottom = 133
	
	sprite.texture = load("res://assets/spaceshooter/PNG/playerShip2_red.png")
	sprite.rotation_degrees = -90

func set_next_character(next_character_index: int) :
	var blue_taxt = get_bbcode_color_tag(green) + prompt_text.substr(0,next_character_index) + get_bbcode_end_color_tag()
	var green_taxt = get_bbcode_color_tag(darkgreen) + prompt_text.substr(next_character_index,1) + get_bbcode_end_color_tag()
	var red_taxt = ""
	
	if next_character_index != prompt_text.length():
		red_taxt = get_bbcode_color_tag(gray) + prompt_text.substr(next_character_index + 1,prompt_text.length() - next_character_index + 1) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(blue_taxt + green_taxt + red_taxt))
	

func set_center_tags(string_to_center: String) :
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String :
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String :
	return "[/color]"







func _on_Area2D_area_entered(area):
	if area.is_in_group("arrow") and alow == true :
		decreased_enemy_hp()
		set_ready()
	elif area.is_in_group("player"):
		queue_free()
		PromptList.enemy_died += 1
	else :
		$Area2D.remove_from_group("enemy")

#func _on_VisibilityNotifier2D_screen_exited():
#	queue_free()
	
