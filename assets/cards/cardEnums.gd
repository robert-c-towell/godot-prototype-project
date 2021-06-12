extends Node

enum {forward, backward, left, right, rotate}

const DATA = {
	forward: {
		"type": "basic",
		"moves": [1,2,3],
		"image": "forward.png",
		"description": "Forward 1, 2, or 3"
	},
	backward: {
		"type": "basic",
		"moves": [1],
		"image": "back.png",
		"description": "Back 1"
	},
	left: {
		"type": "basic",
		"moves": ["Left","U-turn"],
		"image": "left.png",
		"description": "Left or U-turn"
	},
	right: {
		"type": "basic",
		"moves": ["Right","U-turn"],
		"image": "right.png",
		"description": "Right or U-turn"
	},
	rotate: {
		"type": "uncommon",
		"moves": ["Left","Right","U-turn"],
		"description": "Left, Right, or U-turn"
	},
}
