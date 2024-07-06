extends Node2D

var current : bool = false #set to true if this is the minigame that is currently being played

@onready var ball = $ball
@onready var paddle_l = $paddleL
@onready var paddle_r = $paddleR

func _ready():
	$ball/AnimatedSprite2D.play("idle")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$spring.position.y -= 100
	if Input.is_action_just_pressed("left"):
		paddle_l.rotation -= 0.4
	if Input.is_action_just_released("left"):
		paddle_l.rotation += 0.4
	if Input.is_action_just_pressed("right"):
		paddle_r.rotation += 0.4
	if Input.is_action_just_released("right"):
		paddle_r.rotation -= 0.4

func _on_spring_body_entered(body):
	if body.name == "ball":
		ball.linear_velocity.y = -2000

func _on_death_body_entered(body):
	if body.name == "ball":
		$ball/AnimatedSprite2D.play("die")
