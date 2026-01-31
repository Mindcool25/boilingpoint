extends Node2D
@onready var portal = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().reload_current_scene()
