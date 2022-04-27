extends Node2D

var apple_image: StreamTexture = preload("res://assets/images/little_apple16x16.png")
var matrix_of_icons:Dictionary
var row: int = 0
var video_player: VideoPlayer

func _ready() -> void:
	video_player = $VideoPlayer
	OS.window_fullscreen = true



func _process(delta: float) -> void:
	#Se crean 44 columnas y no 45 porque el actualizar cada frame la última realentiza el procesamiento demasiado.
	while (row <= 44):
		place_apples(row)
	take_frame()



func place_apples(var _row: int) -> void:
	var row_dict: Dictionary
	matrix_of_icons[_row] = row_dict
	for index in range(60):
		var node: Sprite = Sprite.new()
		node.texture = apple_image
		node.offset = Vector2(8,8)
		self.add_child(node)
		node.position += Vector2(index*16, row*16)
		matrix_of_icons[_row][index] = node
	row += 1



func take_frame() -> void:
	var frame_image: Image = $VideoPlayer.get_video_texture().get_data()
	
	if frame_image != null:
		frame_image.resize(60, 45, 1)
		
		var width = frame_image.get_width()
		var height = frame_image.get_height()
		frame_image.lock()
		
		for y in range(height):
			for x in range(width):
				var value = frame_image.get_pixel(x,y).r
				matrix_of_icons[y][x].modulate = Color(value,value,value,1)
				
			




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("raise_volume"):
		if (video_player.volume_db >= 10):
			video_player.volume_db = 10
		else:
			video_player.volume_db += 5
	elif event.is_action_pressed("lower_volume"):
		if (video_player.volume_db <= -20):
			video_player.volume_db = -20
		else:
			video_player.volume_db -= 5
	elif event.is_action_pressed("esc"):
		get_tree().quit()
