extends CanvasLayer

@onready var input_label = $InputLabel
@onready var feedback_label = $FeedbackLabel
@onready var door = $"../door5_SM001_door5m_0"
@onready var pinpadUI1=$"../InteractArea"
@onready var pinpadUI2=$"."

var current_input = ""
const CORRECT_CODE = "8420"

func _ready():
	input_label.text = ""
	feedback_label.text = ""

	
	for i in range(10):
		var btn_name = "ButtonsContainer/Button" + str(i)
		if has_node(btn_name):
			var button = get_node(btn_name)
			button.pressed.connect(_on_button_pressed.bind(i))
			print("Connected:", btn_name)  # Debug


	$ButtonsContainer/ButtonClear.pressed.connect(_on_clear_pressed)
	$ButtonsContainer/ButtonEnter.pressed.connect(_on_enter_pressed)

func _on_button_pressed(value: int):
	print("Pressed:", value)  
	if current_input.length() < 4:
		current_input += str(value)
		input_label.text = current_input

func _on_clear_pressed():
	current_input = ""
	input_label.text = ""
	feedback_label.text = ""

func _on_enter_pressed():
	if current_input == CORRECT_CODE:
		feedback_label.text = "Unlocked!"
		door.rotation_degrees.y = 90
		door.position.x = 0.462
		door.position.z = -0.152
		pinpadUI1.queue_free()
		pinpadUI2.queue_free()
		
		
	else:
		feedback_label.text = "Incorrect"
	current_input = ""
	input_label.text = ""
