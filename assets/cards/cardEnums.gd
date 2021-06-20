extends Node

enum cards {forward, backward, left, right, rotate, u_turn}
enum properties {type,moves,image,description}

const DATA = {
	cards.forward: {
		properties.type: "basic",
		properties.moves: [1,2,3],
		properties.image: "forward.png",
		properties.description: "Forward 1, 2, or 3"
	},
	cards.backward: {
		properties.type: "basic",
		properties.moves: [1],
		properties.image: "back.png",
		properties.description: "Back 1"
	},
	cards.left: {
		properties.type: "basic",
		properties.moves: ["Left","U-turn"],
		properties.image: "left.png",
		properties.description: "Left or U-turn"
	},
	cards.right: {
		properties.type: "basic",
		properties.moves: ["Right","U-turn"],
		properties.image: "right.png",
		properties.description: "Right or U-turn"
	},
	cards.rotate: {
		properties.type: "uncommon",
		properties.moves: ["Left","Right","U-turn"],
		properties.description: "Left, Right, or U-turn"
	},
	cards.u_turn: {
		properties.type: "uncommon",
		properties.moves: ["U-turn"],
		properties.description: "U-turn"
	}
}
