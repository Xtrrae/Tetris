extends StaticBody2D
var moveDown = true 
var moveX = true
var collision = false
var rightCollide = false
var leftCollide = false
var topCollide = false 
var bottomCollide


func _on_timer_timeout() -> void:
 if !collision:
  self.position.y += 32 


func _process(_delta) -> void:
#timer restart
 if $fall_timer.time_left == 0: 
  $fall_timer.start() 
#ground check 
 if collision == true: 
   self.set_process(false)
   $Right.queue_free()
   $Left.queue_free()
   $Down.queue_free()
   $Top.queue_free()
#move
 if Input.is_action_pressed("move_right") && moveX == true && rightCollide == false: 
  self.position.x += 32
  moveX = false
  $moveX_timer.start()
 if Input.is_action_pressed("move_left") && moveX == true && leftCollide == false:
  self.position.x -= 32
  moveX = false
  $moveX_timer.start()
 if Input.is_action_pressed("move_down") && moveDown == true:
  self.position.y += 32
  moveDown = false
  $moveY_timer.start()
#rotate
 if Input.is_action_just_pressed("rotate_right"): 
  self.rotation_degrees += 90
  self.position.x += 16
  self.position.y += 16
  if self.rotation_degrees >= 360:
   self.rotation_degrees = 0
  print(self.rotation_degrees)
 if Input.is_action_just_pressed("rotate_left"): 
  self.rotation_degrees -= 90
  self.position.x -= 16
  self.position.y += 16
  if self.rotation_degrees <= -360:
   self.rotation_degrees = 0
  print(self.rotation_degrees)

func _on_move_timer_timeout() -> void: 
 moveDown = true
 
func _on_move_x_timer_timeout() -> void:
 moveX = true

 
func _on_right_area_exited(area) -> void:

 if area.is_in_group("LeftWall"):
  leftCollide = false
 elif  area.is_in_group("RightWall"):
  rightCollide = false
  
func _on_right_area_entered(area) -> void:
 
 if area.is_in_group("Ground"):
  collision = true 
  print("right")
 elif area.is_in_group("LeftWall"):
  leftCollide = true
  print("right")
 elif  area.is_in_group("RightWall"):
  print("right")
  rightCollide = true


func _on_left_area_entered(_area) -> void:
 print("left")
 if self.rotation_degrees == -90 || self.rotation_degrees == 270:
  collision = true
 elif self.rotation_degrees == 0:
  leftCollide = true
 elif  self.rotation_degrees == 180 || self.rotation_degrees == -180:
  rightCollide = true



func _on_left_area_exited(area) -> void:
 if area.is_in_group("LeftWall"):
  leftCollide = false
 elif  area.is_in_group("RightWall"):
  rightCollide = false

func _on_down_area_entered(area) -> void:
 print("down")
 if area.is_in_group("Ground"):
  collision = true
 elif is_in_group("LeftWall"):
  leftCollide = true
 elif  area.is_in_group("RightWall"):
  rightCollide = true

func _on_down_area_exited(area) -> void:
 if area.is_in_group("LeftWall"):
  leftCollide = true
 elif  area.is_in_group("RightWall"):
  rightCollide = true
