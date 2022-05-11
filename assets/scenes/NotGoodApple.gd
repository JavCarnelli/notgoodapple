extends Node2D

#Definition of constants. The WIDHT and HEIGHT indicates the amount of apples that will
#be created to use as pixels.
const WIDTH = 60
const HEIGHT = 45

#Import of the icon used as pixel - It has a resolution of 16 x 16 px
var apple_image: StreamTexture = preload("res://assets/images/little_apple16x16.png")

#This array will be used as a Matrix to contain the references to the icons and modulate their color
var matrix_of_icons = []
var video_player: VideoPlayer


#The _ready() function will be executed at first and will save the reference of the VideoPlayer
#It'll also set the fullscreen mode and create all the apples to be used as icons.
func _ready() -> void:
	video_player = $VideoPlayer
	OS.window_fullscreen = true
	place_apples()


#In the process function (executed every frame) the take_frame() method will be runned
func _physics_process(delta: float) -> void:
	take_frame()


#This method will create the icons and locate them in the right position.
#It also fills the matrix_of_icons with the correct references, using the x and y
#position of them to access the corresponding reference.
func place_apples() -> void:
	for x in range(WIDTH):
		matrix_of_icons.append([])
		for y in range(HEIGHT):
			var node: Sprite = Sprite.new()
			node.texture = apple_image
			node.offset = Vector2(8,8)
			self.add_child(node)
			node.position += Vector2(x*16, y*16)
			matrix_of_icons[x].append(node)


#This method will take every frame when it's displayed and it'll do some work on it:
#	- The frame taken will be resized down to 60x45px (like the matrix of 
#	  apples we have created.
#	- The data collected (the image of the corresponding frame) will be locked 
#	  to allow us to read every pixel it has.
#	- We will iterate on each pixel of the image and modulate the corresponding
#	  apple icon (acording to the x and y position of the pixel) with black or white
#	  as appropriate.
func take_frame() -> void:
	var frame_image: Image = $VideoPlayer.get_video_texture().get_data()
	
	if frame_image != null:
		frame_image.resize(60, 45, 1)
		
		var width = frame_image.get_width()
		var height = frame_image.get_height()
		frame_image.lock()
		
		for x in range(WIDTH):
			for y in range(HEIGHT):
				var value = frame_image.get_pixel(x,y).r
				matrix_of_icons[x][y].modulate = Color(value,value,value,1)


#Here, the inputs will be checked. If the user press "esc", the app will close.
#Using the "+", "-" buttons or the up and down arrows, will allow to adjust
#the volume a little bit.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("raise_volume"):
		if (video_player.volume_db >= 5):
			video_player.volume_db = 5
		else:
			video_player.volume_db += 5
		
	elif event.is_action_pressed("lower_volume"):
		if (video_player.volume_db <= -20):
			video_player.volume_db = -20
		else:
			video_player.volume_db -= 5
		
	elif event.is_action_pressed("esc"):
		get_tree().quit()
