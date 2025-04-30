extends Furniture
var books = null
var is_green = false
func _ready():
	super()
	SignalBus._highlight_bookshelf.connect(highlight)
	SignalBus._update_highlight.connect(on_update_highlight)


func on_update_highlight(points, color, clear):
	if clear:
		modulate = Color.WHITE
		is_green = false
func highlight():
	modulate = Color.GREEN
	is_green = true
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
	
func _process(delta):
	if !is_in_correct_spot() and !is_green:
		modulate = Color(1,0,0,modulate.a)
	elif !is_green:
		modulate = Color(1,1,1,modulate.a)
