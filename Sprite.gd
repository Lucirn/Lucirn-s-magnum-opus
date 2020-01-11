extends Sprite
var textura=preload("res://gost2.2.png")
var texturz=preload("res://gost2.png")
var textury=preload("res://gost.png")
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		self.texture=textura
	else:
		if Input.is_action_pressed("move_right"):
			self.texture=texturz
		else:
			self.texture=textury
	


