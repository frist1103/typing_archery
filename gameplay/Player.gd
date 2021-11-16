extends Node2D

onready var  player_hp_label = $PlayerHpLabel

var player_hp = 3

func _ready():
	re_hp()

func decreased_player_hp ():
	player_hp -= 1
	player_hp_label.text = str(player_hp)

func re_hp():
	player_hp = 3
	player_hp_label.text = str(player_hp)

func damage_boss():
	player_hp = 0
	player_hp_label.text = str(player_hp)
