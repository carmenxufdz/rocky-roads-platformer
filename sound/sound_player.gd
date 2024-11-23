extends Node

const LOOSE = preload("res://sound/loose.wav")
const JUMP = preload("res://sound/jump.wav")
const COIN = preload("res://sound/coin.wav")
const HURT = preload("res://sound/hurt.wav")
const ZAP = preload("res://sound/zap.wav")
const BOOM = preload("res://sound/boom.wav")

@onready var audioPlayers: = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
