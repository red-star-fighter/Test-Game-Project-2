extends Label

@onready var player = get_node("../CollisionShape2D")
var score = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Checks player score and updates max score.
	if player.global_transform.origin.y > int(score):
		score = str(int(player.global_transform.origin.y))
		self.text = score
	pass
