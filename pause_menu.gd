extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		$".".visible = !$".".visible


func _on_continue_pressed():
	$".".visible = false


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Main Menu.tscn")
