extends StaticBody2D
var moveDown = true 
var moveX = true
var collision = false

@onready var rayDown = $RayDown
@onready var rayRight = $RayRight
@onready var rayLeft = $RayLeft

func _on_timer_timeout() -> void:
 if !collision:
  self.position.y += 32 


func _process(_delta) -> void:

 if $fall_timer.time_left == 0: 
  $fall_timer.start() 
  
 if rayDown.is_colliding():  
  self.set_process(false)
  print("collision")
  collision = true
 if Input.is_action_pressed("move_right") && moveX == true && !rayRight.is_colliding(): 
  self.position.x += 32
  moveX = false
  $moveX_timer.start()
 if Input.is_action_pressed("move_left") && moveX == true && !rayLeft.is_colliding():
  self.position.x -= 32
  moveX = false
  $moveX_timer.start()
 if Input.is_action_pressed("move_down") && moveDown == true:
  self.position.y += 32
  moveDown = false
  $moveY_timer.start()
 




  

 


func _on_move_timer_timeout() -> void: 
 moveDown = true
 

func _on_move_x_timer_timeout() -> void:
 moveX = true
 
