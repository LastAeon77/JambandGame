extends Furniture
var books = null
func pick_up():
	if moveable and on_ground:
		if books == null:
			on_ground = false
			remove_from_group("obstacles")
			visible = false
			return self
		else:
			var result = books.pick_up()
			if result != null:
				flipped_animation.play("default")
				animation.play("default")
				books = null
			return result
		
	return null
func place_books(books_to_place):
	self.books = books_to_place
	flipped_animation.play("full")
	animation.play("full")
