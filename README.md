# Card and Hand Scenes

<img width="592" alt="image" src="https://github.com/zondug/card_game/assets/13306437/27b74722-9957-4b82-a728-8c54beb7d6cd">


## Card Scene (`card.tscn`)

The `card.tscn` scene represents an individual card in the game. It has the following features and behaviors:

- The card is displayed using a `Sprite2D` node named `CardSprite`.
- A shadow effect is created using another `Sprite2D` node named `ShadowSprite`.
- The card has a label (`Label` node) for displaying text or numbers on the card.
- An `Area2D` node is used for detecting mouse input events on the card.
- The card supports dragging functionality. When the user clicks and drags the card, it follows the mouse position.
- The card has a hover effect. When the mouse enters the card area, the card scales up and moves in the direction of its original rotation.
- When the mouse exits the card area or the card is dropped, it returns to its original position and scale.
- The card uses a custom shader (`card_shader.gdshader`) to create a visual effect when the card is hovered over.

## Hand Scene (`hand.tscn`)

The `hand.tscn` scene represents a collection of cards arranged in a hand-like layout. It has the following features:

- The hand scene contains multiple instances of the `card.tscn` scene as child nodes.
- The cards are arranged in an arc shape, simulating a hand of cards.
- The positioning and rotation of the cards are calculated based on the number of cards and the desired arc angle.
- The hand scene can be customized by adjusting parameters such as the number of cards, arc angle, and card spacing.

## Dependencies

The card and hand scenes have the following dependencies:

- Godot Engine (version 4.2)
- `card_shader.gdshader` file for the card hover effect

Make sure to have the required dependencies set up in your project before using the card and hand scenes.

## License

This project is licensed under the [MIT License](LICENSE).

Feel free to use, modify, and distribute the code and assets in this project for both personal and commercial purposes. Attribution is appreciated but not required.

If you have any questions or suggestions, please feel free to contact the project maintainer.

Enjoy creating your card game!
