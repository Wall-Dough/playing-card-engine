extends Sprite2D

var start_card = null
var start_mouse = null
var card_value = "Joker"
var face_up = true
var zone = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func refresh_image():
    var card_value = self.card_value
    if !face_up:
        card_value = "Back_Red"
    var image = Image.load_from_file("res://Neon Orbis Playing Cards/Cards/" + card_value + ".png")
    var texture = ImageTexture.create_from_image(image)
    self.texture = texture

func enter_zone(zone):
    self.position = Vector2(zone.position)
    if zone.change_on_enter:
        set_face_up(zone.face_up_on_enter)
    self.zone = zone

func exit_zone():
    if zone == null:
        return
    if zone.change_on_exit:
        set_face_up(zone.face_up_on_exit)
    zone = null

func set_card_value(card_value):
    self.card_value = card_value
    if !face_up:
        return
    refresh_image()

func set_face_up(face_up):
    if face_up == self.face_up:
        return
    self.face_up = face_up
    refresh_image()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func is_clicked(position):
    var size = self.get_rect().size
    return (position.x > self.position.x - (size.x / 2) and
            position.y > self.position.y - (size.y / 2) and
            position.x < self.position.x + (size.x / 2) and
            position.y < self.position.y + (size.y / 2))

func start_move(position):
    start_mouse = Vector2(position)
    start_card = Vector2(self.position)

func end_move():
    start_mouse = null
    start_card = null

func _input(event):
    if (start_card != null and 
        start_mouse != null and
        event is InputEventMouseMotion):
        var mouse_diff = event.position - start_mouse
        if mouse_diff.x != 0 or mouse_diff.y != 0:
            exit_zone()
        self.position = start_card + mouse_diff
