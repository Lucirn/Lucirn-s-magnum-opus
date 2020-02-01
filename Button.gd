extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	cells_load()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var cells=$"../../TileMap".get_used_cells()
	print(cells)
	cells_save(cells)




func cells_save(cells):
	var file=File.new()
	file.open("res://save.dat",file.WRITE)
	file.store_var(cells)
	file.close()
	#var cells_new=[]
	#for cell in cells:
	#	cells_new.append(Vector3

func cells_load():
	var file=File.new()
	if file.file_exists("res://save.dat"):
		file.open("res://save.dat", File.READ)
		var cells=file.get_var()
		file.close()
		var tilemap=$"../../TileMap"
		tilemap.clear()
		for cell in cells:
			print(cell)
			tilemap.set_cellv(cell,0)