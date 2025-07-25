extends TileMapLayer

@onready var background: TileMapLayer = $"../Background"
@onready var hud: CanvasLayer = $"../HUD"


#tetrominoes
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_180 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0, o_90, o_180, o_270]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var shapes := [i, t, o, z, s, l, j]

const COLS : int = 10
const ROWS : int = 20

const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var steps : Array
const steps_req : int = 50
const start_pos := Vector2i(5, 1)
const next_start_pos := Vector2i(15, 6)
var cur_pos : Vector2i
var speed : float

var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

var tile_id : int = 3
var piece_atlas : Vector2i 
var next_piece_atlas : Vector2i
var shuffle_bag : Array

var row_clear_count : int
var rows_to_next_level := 4 
var level := 1

var score := 0
var game_over = false

func _ready():
	new_game()

func new_game():
	speed = 0.5 
	steps = [0, 0 , 0] #Left  right  down 
	score = 0
	remove_piece(active_piece, cur_pos)
	clear_game()
	
	
	hud.get_node("gameOverLabel").hide()
	hud.get_node("startButton").disabled = true
	hud.get_node("startButton").hide()

	
	create_piece()
	update_next_piece()
#shuffle bag, picks next piece, and current piece
func pick_piece():
	var piece
	if shuffle_bag.is_empty(): 
		shuffle_bag = shapes.duplicate()
		shuffle_bag.shuffle()

	piece = shuffle_bag.front()
	
	piece_atlas = Vector2i(shapes.find(piece), 0)
	print(piece_atlas)
	shuffle_bag.pop_front()

	if shuffle_bag.is_empty(): 
		shuffle_bag = shapes.duplicate()
		shuffle_bag.shuffle()


	next_piece_type = shuffle_bag.front()
	next_piece_atlas = Vector2i(shapes.find(next_piece_type), 0)

	return piece

func create_piece(): 
	piece_type = pick_piece()
	steps = [0, 0, 0]
	cur_pos = start_pos	
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)
	
func _process (_delta):
	
	#player input
	if Input.is_action_pressed("move_left"):
		steps[0] += 4
	elif Input.is_action_pressed("move_right"):
		steps[1] += 4
	elif Input.is_action_pressed("move_down"):
		steps[2] += 4
	if Input.is_action_just_pressed("rotate"):
		rotate_piece()

	steps[2] += speed
	for k in range(steps.size()):
		if steps[k] > steps_req:
			move_piece(directions[k])
			steps[k] = 0
	
	if game_over == true && hud.get_node("startButton").start_game == true: 
		new_game()
		hud.get_node("startButton").start_game = false
		game_over = false

func draw_piece(piece, pos, atlas):
	for k in piece: 
		set_cell(pos + k, tile_id, atlas)

func remove_piece(piece, pos):
	for k in piece: 
		erase_cell(pos + k)

func move_piece(dir):
	if can_move(dir):
		remove_piece(active_piece, cur_pos)
		cur_pos += dir 
		draw_piece(active_piece, cur_pos, piece_atlas)
	else: 
		if dir == Vector2i.DOWN: 
			land_piece()
			game_over_check()
			if game_over == false:
				check_row()
				row_clear_count = 0
				create_piece()
				update_next_piece()

func rotate_piece(): 
	if can_rotate():
		rotation_index = (rotation_index + 1) % 4 
		remove_piece(active_piece, cur_pos)
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, cur_pos, piece_atlas)

func can_rotate():
	var cr = true
	var temp_rotation_index = (rotation_index + 1) % 4
	for k in piece_type[temp_rotation_index]:
		
		if not is_free(k + cur_pos + Vector2i(1, 0)):
			cr = false 
	return cr

func can_move(dir):
	var cn = true
	for k in active_piece:
		if not is_free(k + cur_pos + dir + Vector2i(1, 0)):
			cn = false
			
	return cn

func is_free(pos): 
	if background.get_cell_source_id(pos) == -1:
		return true
	return false 
	
func update_next_piece(): 
	remove_piece(piece_type[0], next_start_pos)
	draw_piece(next_piece_type[0], next_start_pos, next_piece_atlas)

func land_piece():
	for k in active_piece:
		erase_cell(cur_pos + k)
		background.set_cell(cur_pos + k + Vector2i(1, 0), tile_id, piece_atlas)
		

func check_row(): 
	var row : int = ROWS
	while row > 0:
		var count = 0
		for k in range(COLS):
			if not is_free(Vector2i(k + 1, row)):
				count += 1
				
				
		if count == COLS:
			shift_rows(row)
			row_clear_count += 1
		else:
			row -= 1
	if row_clear_count == 1:
		score += 40 * level
	elif row_clear_count == 2:
		score += 100 * level
	elif row_clear_count == 2:
		score += 300 * level
	elif row_clear_count == 2:
		score += 1200 * level
	hud.get_node("scoreLabel").text = "score:"  + str(score)	

	rows_to_next_level -= row_clear_count

	if rows_to_next_level <= 0 && level < 9:
		level += 1
		speed += 0.25
		rows_to_next_level = (4 + (2 * level))

func shift_rows(row):
	var atlas   
	for x in range(row, 1, -1):
		for k in range(COLS):
			atlas = background.get_cell_atlas_coords(Vector2i(k + 2, x - 1))
			if atlas == Vector2i(-1, -1):
				background.erase_cell(Vector2i(k + 2, x))
			else: 
				background.set_cell(Vector2i(k + 2, x), tile_id, atlas)
			

func game_over_check():
	for k in range(COLS):
		if not is_free(Vector2i(k + 2, 1)):
			game_over = true
			land_piece()
			hud.get_node("gameOverLabel").visible = true
			hud.get_node("startButton").visible = true
			hud.get_node("startButton").disabled = false

func clear_game():
	for x in range(ROWS):
		for k in range(COLS):
			background.erase_cell(Vector2i(k + 2, x + 1))
	hud.get_node("scoreLabel").text = "score:0"	
	
