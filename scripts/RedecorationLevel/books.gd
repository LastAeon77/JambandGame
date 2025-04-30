extends Furniture
var on_shelf = false

func place(placement_data = null):
	if placement_data != null and placement_data.is_in_group("bookshelf"):
		placement_data.place_books(self)
		on_shelf = true
		return true
	elif placement_data == null:
		on_ground=true
		add_to_group("obstacles")
		visible = true
		return true
	return false

func pick_up():
	on_ground = false
	on_shelf = false
	remove_from_group("obstacles")
	visible = false
	return self
	
func is_in_correct_spot():
	return on_shelf

func draw_desired_highlight():
	super.draw_desired_highlight()
	SignalBus._highlight_bookshelf.emit()
