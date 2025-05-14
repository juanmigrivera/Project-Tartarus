extends Panel

@onready var dialogue_label = $DialogueLabel1
@onready var continue_label = $DialogueLabel1/ContinueLabel
@onready var typing_timer = $TypingTimer

var dialogue_lines = [
	"Hmm...This is Hospital Tartarus huh...well, time to get to work.",
	"The power seems to be weak (Press F to turn on/off flashlight)",
	"The mission debrief said there were hidden messages in this hospital, I should be on the lookout for them.",
	"Press Q to toggle UV flashlight",
	"Luckily I brought my bag with me to carry these cures",
	"Press TAB to open inventory",
	"Press H for Hints"
]

var current_line = 0
var full_text = ""
var display_text = ""
var char_index = 0
var is_typing = false

func _ready():
	continue_label.text = ""
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	show_line()

func show_line():
	if current_line < dialogue_lines.size():
		full_text = dialogue_lines[current_line]
		display_text = ""
		char_index = 0
		dialogue_label.text = ""
		is_typing = true
		continue_label.text = ""
		typing_timer.start()
	else:
		hide()  # or emit a signal, or queue_free()

func _on_typing_timer_timeout():
	if char_index < full_text.length():
		display_text += full_text[char_index]
		dialogue_label.text = display_text
		char_index += 1
	else:
		typing_timer.stop()
		is_typing = false
		continue_label.text = "Press Enter to continue"

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			
			typing_timer.stop()
			dialogue_label.text = full_text
			is_typing = false
			continue_label.text = "Press Enter to continue"
		else:
			continue_label.text = ""
			current_line += 1
			show_line()
