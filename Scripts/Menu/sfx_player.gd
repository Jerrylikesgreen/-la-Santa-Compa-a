class_name SfxPlayer extends AudioStreamPlayer


enum SfxTrack {BUTTON, CANCEL, NOTIFICATION, TEXT_CLICK}
var current_sfx_track: SfxTrack

@export var sfx_tracks: Dictionary[SfxTrack, AudioStream]
