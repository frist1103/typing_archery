extends Area2D

export var arrow_speed: int = 1500

func _ready():
	GlobalSignals.connect("use_skill",self,"use_skill")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += arrow_speed * direction * delta

func destroy():
	queue_free()

func use_arrow_skill():
	$Sprite.scale = Vector2(10 , 10)
	print("arrow skill")

#func _on_Arrow_body_entered(body):
#	destroy()


func _on_Arrow_area_entered(area):
	if area.is_in_group("enemy"):
		destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()
