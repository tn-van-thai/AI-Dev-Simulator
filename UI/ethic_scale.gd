extends RichTextLabel

@export var text_speed := 0.09   # seconds per character
var full_text := ""
var index := 0

func start_text(value):
    full_text = "Ethics Score : " + str(int(((value + 140) / 380.0) * 100)) + "%"
    text = full_text
    visible_characters = 0
    index = 0
    type_text()

func type_text():
    while index <= full_text.length():
        visible_characters = index
        index += 1
        await get_tree().create_timer(text_speed).timeout
