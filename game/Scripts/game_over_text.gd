extends RichTextLabel

func _ready() -> void:
    if GameManager.mistakes_left <= 0:
        text = "EMPLOYMENT TERMINATED"
    else:
        text = "LOYALTY DEMONSTRATED."

    GameManager.mistakes_left = 3  # Reset mistakes for next game

