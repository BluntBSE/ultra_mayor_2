extends Node
class_name SoundConnector
## Probably need to replace this with a better system but eh


var playback:AudioStreamPlaybackPolyphonic


func _enter_tree() -> void:
	# Create an audio player
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream:AudioStreamPolyphonic = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_pop()->void:
	playback.play_stream(preload('res://engine/tile_level/common/sounds/pop.mp3'), 0, 1.0, randf_range(0.9, 1.1))


func _play_hover() -> void:
	playback.play_stream(preload('res://engine/tile_level/common/sounds/blah.mp3'), 0, -10.0, randf_range(0.9, 1.1))


func _play_pressed() -> void:
	playback.play_stream(preload('res://engine/tile_level/common/sounds/sweep.mp3'), 0, 0, randf_range(0.9, 1.1))
