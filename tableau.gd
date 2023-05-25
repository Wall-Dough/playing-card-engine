extends Node2D

var card_stack
var clicked_card

# Called when the node enters the scene tree for the first time.
func _ready():
    card_stack = []
    # Generate card values
    var suits = ['C','D','H','S']
    var indices = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
    var card_values = []
    for suit in suits:
        for index in indices:
            card_values.push_back(suit + index)
    # Duplicate base card and set values
    for i in range(0, card_values.size()):
        var new_card = $card.duplicate()
        new_card.set_card_value(card_values[i])
        new_card.visible = true
        new_card.z_index = i + 1
        card_stack.push_back(new_card)
        add_child(new_card)
        new_card.enter_zone($zone1)
    # Shuffle cards and reset z values
    card_stack.shuffle()
    for i in range(0, card_stack.size()):
        var card = card_stack[i]
        card.z_index = i + 1
    clicked_card = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            for card in card_stack:
                if card.is_clicked(event.position):
                    if clicked_card == null:
                        clicked_card = card
                    elif card.z_index > clicked_card.z_index:
                        clicked_card = card
            if clicked_card != null:
                card_stack.erase(clicked_card)
                card_stack.push_back(clicked_card)
                for i in range(0, card_stack.size()):
                    card_stack[i].z_index = i + 1
                clicked_card.start_move(event.position)
                
        else:
            if clicked_card != null:
                clicked_card.end_move()
                clicked_card = null
