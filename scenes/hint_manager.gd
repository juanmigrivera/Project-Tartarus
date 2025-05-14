extends Panel

@onready var hint_label: Label = $Label
@onready var intro_audio = $IntroDialogueAudio

var hint_index := 0
var current_hints: Array[String] = []
var showing_hint := false
var intro_played := false

var intro: Array[String] = [
	"This is Blackbird-One. Do you read me? …There you are. Finally got a signal through.",
	"Listen — we don’t have much time.",
	"We need you to get the cure and get out. Follow my instructions.",
	"Just don’t trust what you see."
]

var all_hints = {
	"puzzle_1": [
		"We're reading red power spikes in four sectors. Stabilize the circuits — flip anything still blinking.",
		"Half the panels are cold. Ignore those. Focus on the ones pulsing red.",
		"Once they all show green, the lock should disengage. Be quick — we can’t hold this signal long."
	] as Array[String],
	"puzzle_2": [
		"Their bodies are everywhere...",
		"You're locked out. The security cards are on the agents. You’ll need all to trigger the override.",
		"static"
	] as Array[String],
	"puzzle_3": [
		"This room’s off the map… No feed, Be careful.",
		"We think they embedded the exit code in the walls — or maybe ....pai...(static)",
		"Wait. You're not alone in that room anymore.",
		"Just go. RUN."
	] as Array[String]
}

func _ready():
	hide()
	start_intro()

func start_intro():
	intro_audio.play()
	_show_intro_lines()

func _show_intro_lines():
	for line in intro:
		hint_label.text = line
		show()
		await get_tree().create_timer(4.0).timeout
		hide()
		await get_tree().create_timer(0.5).timeout
	intro_played = true
	print("Intro running. Current hints should be untouched.")
	print("Current hints (should be empty or irrelevant): ", current_hints)

func show_hints(puzzle_id: String):
	if all_hints.has(puzzle_id):
		current_hints = all_hints[puzzle_id]
		hint_index = 0

func _input(event):
	if event.is_action_pressed("walkie_talkie") and not showing_hint and intro_played:
		_show_next_hint()

func _show_next_hint():
	if hint_index >= current_hints.size():
		hide()
		hint_index = 0
		showing_hint = false
		return

	hint_label.text = current_hints[hint_index]
	show()
	showing_hint = true
	hint_index += 1

	await get_tree().create_timer(4.0).timeout
	hide()
	showing_hint = false
