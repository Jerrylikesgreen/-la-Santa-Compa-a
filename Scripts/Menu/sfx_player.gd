class_name SfxPlayer extends AudioStreamPlayer


enum SfxTrack {BUTTON, CANCEL, NOTIFICATION, TEXT_CLICK}

@export var sfx_bank: Dictionary[SfxTrack, AudioStream]

var _current_track : SfxTrack        


func play_track(track: SfxTrack) -> void:

	_switch_stream(track)
	play()
	print_debug("Track being played: %s" % track)

func _switch_stream(track: SfxTrack) -> void:

	if sfx_bank[track] == null:
		push_warning("SFX bank entry %d is empty" % track)
		return
	_current_track = track
	stream = sfx_bank[track]
