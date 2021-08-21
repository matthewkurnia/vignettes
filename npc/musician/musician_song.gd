extends AudioStreamPlayer2D


onready var tween = $Tween


func fade_in():
	tween.interpolate_property(self, "volume_db", self.volume_db, 3, 0.4)
	tween.start()


func fade_out():
	tween.interpolate_property(self, "volume_db", self.volume_db, -80, 0.4)
	tween.start()
