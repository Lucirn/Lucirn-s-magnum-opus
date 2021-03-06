extends KinematicBody2D

var kok=0

func _ready():
	add_to_group("Player")

# Member variables
const GRAVITY = 300.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _physics_process(delta):
	mouse_action()
	
	var force = Vector2(0, GRAVITY)
	
	if Input.is_action_pressed("1"):
		kok=0
	
	
	if Input.is_action_pressed("2"):
		kok=1
	
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	

func reycast(from,to):
	var space_state=get_world_2d().direct_space_state
	return space_state.intersect_ray(from,to,[self])
	
func mouse_action():
	if Input.is_action_just_pressed("Mouse"):
		var mpos=get_global_mouse_position()
		var call=reycast(self.position,mpos)
		print(call)
		if call:
			var cell=$"../TileMap".world_to_map(call.position+call.normal)
			$"../TileMap".set_cell(cell.x,cell.y,kok)
	if Input.is_action_just_pressed("right_click"):
		var mpos=get_global_mouse_position()
		var call=reycast(self.position,mpos)
		print(call)
		if call:
			var cell=$"../TileMap".world_to_map(call.position-call.normal)
			$"../TileMap".set_cell(cell.x,cell.y,-1)
	
	

