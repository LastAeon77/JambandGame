extends Furniture

func place(placement_data = null):
	if placement_data != null and placement_data.is_in_group("bookshelf"):
		placement_data.place_books(self)
		return true
	elif placement_data == null:
		on_ground=true
		add_to_group("obstacles")
		SignalBus._obstacle_changed.emit()
		visible = true
		return true
	return false
	
