extends Furniture
var books = null

func pick_up():
	if moveable and on_ground:
		if books == null:
			on_ground = false
			remove_from_group("obstacles")
			visible = false
			SignalBus._obstacle_changed.emit()
			SignalBus._bookshelf_state_changed.emit(false)
			return self
		else:
			flipped_animation.play("default")
			animation.play("default")
			SignalBus._bookshelf_state_changed.emit(false)
			return books.pickup()
		
	return null
func place_books(books):
	self.books = books
	flipped_animation.play("full")
	animation.play("full")
	SignalBus._bookshelf_state_changed.emit(true)
