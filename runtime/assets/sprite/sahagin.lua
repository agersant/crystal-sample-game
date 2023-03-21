return {
	crystal_spritesheet = true,
	texture = "assets/sprite/sahagin.png",
	frames = {
		frame_0 = { x = 118, y = 98, w = 26, h = 25, },
		frame_1 = { x = 0, y = 24, w = 23, h = 46, },
		frame_2 = { x = 65, y = 24, w = 23, h = 40, },
		frame_3 = { x = 154, y = 23, w = 26, h = 23, },
		frame_4 = { x = 49, y = 0, w = 49, h = 24, },
		frame_5 = { x = 61, y = 64, w = 38, h = 24, },
		frame_6 = { x = 149, y = 0, w = 26, h = 23, },
		frame_7 = { x = 0, y = 0, w = 49, h = 24, },
		frame_8 = { x = 23, y = 46, w = 38, h = 24, },
		frame_9 = { x = 168, y = 72, w = 24, h = 22, },
		frame_10 = { x = 98, y = 0, w = 23, h = 46, },
		frame_11 = { x = 95, y = 88, w = 23, h = 34, },
		frame_12 = { x = 127, y = 27, w = 27, h = 23, },
		frame_13 = { x = 180, y = 0, w = 22, h = 26, },
		frame_14 = { x = 168, y = 46, w = 22, h = 26, },
		frame_15 = { x = 118, y = 73, w = 28, h = 25, },
		frame_16 = { x = 61, y = 88, w = 34, h = 23, },
		frame_17 = { x = 23, y = 24, w = 42, h = 22, },
		frame_18 = { x = 144, y = 98, w = 24, h = 26, },
		frame_19 = { x = 0, y = 96, w = 33, h = 25, },
		frame_20 = { x = 33, y = 99, w = 28, h = 29, },
		frame_21 = { x = 121, y = 0, w = 28, h = 27, },
		frame_22 = { x = 33, y = 70, w = 28, h = 29, },
		frame_23 = { x = 99, y = 46, w = 28, h = 27, },
		frame_24 = { x = 146, y = 50, w = 22, h = 28, },
		frame_25 = { x = 0, y = 70, w = 32, h = 26, },
	},
	animations = {
		["attack"] = {
			loop = false,
			sequences = {
				{
					direction = "East",
					keyframes = {
						{
							frame = "frame_6", duration = 0.3, x = -15, y = -19,
							hitboxes = {
								["weak"] = { rect = { x = -9, y = -15, w = 14, h = 15 } },
							},
						},
						{
							frame = "frame_7", duration = 0.08, x = -12, y = -19,
							hitboxes = {
								["hit"] = { rect = { x = 10, y = -7, w = 24, h = 7 } },
								["weak"] = { rect = { x = -5, y = -15, w = 13, h = 16 } },
							},
						},
						{
							frame = "frame_8", duration = 0.082, x = -12, y = -19,
							hitboxes = {
								["weak"] = { rect = { x = -6, y = -16, w = 15, h = 16 } },
							},
						},
					},
				},
				{
					direction = "North",
					keyframes = {
						{
							frame = "frame_9", duration = 0.301, x = -11, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -6, y = -14, w = 14, h = 14 } },
							},
						},
						{
							frame = "frame_10", duration = 0.079, x = -12, y = -41,
							hitboxes = {
								["hit"] = { rect = { x = 1, y = -38, w = 7, h = 24 } },
								["weak"] = { rect = { x = -7, y = -13, w = 16, h = 14 } },
							},
						},
						{
							frame = "frame_11", duration = 0.084, x = -12, y = -29,
							hitboxes = {
								["weak"] = { rect = { x = -6, y = -13, w = 14, h = 13 } },
							},
						},
					},
				},
				{
					direction = "West",
					keyframes = {
						{
							frame = "frame_3", duration = 0.302, x = -11, y = -19,
							hitboxes = {
								["weak"] = { rect = { x = -5, y = -15, w = 15, h = 15 } },
							},
						},
						{
							frame = "frame_4", duration = 0.081, x = -37, y = -19,
							hitboxes = {
								["hit"] = { rect = { x = -34, y = -7, w = 24, h = 7 } },
								["weak"] = { rect = { x = -8, y = -15, w = 14, h = 16 } },
							},
						},
						{
							frame = "frame_5", duration = 0.083, x = -26, y = -19,
							hitboxes = {
								["weak"] = { rect = { x = -8, y = -15, w = 13, h = 16 } },
							},
						},
					},
				},
				{
					direction = "South",
					keyframes = {
						{
							frame = "frame_0", duration = 0.301, x = -12, y = -21,
							hitboxes = {
								["weak"] = { rect = { x = -8, y = -15, w = 17, h = 16 } },
							},
						},
						{
							frame = "frame_1", duration = 0.082, x = -12, y = -18,
							hitboxes = {
								["hit"] = { rect = { x = -9, y = 1, w = 7, h = 24 } },
								["weak"] = { rect = { x = -7, y = -13, w = 16, h = 13 } },
							},
						},
						{
							frame = "frame_2", duration = 0.081, x = -12, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -13, w = 17, h = 13 } },
							},
						},
					},
				},
			},
		},
		["idle"] = {
			loop = false,
			sequences = {
				{
					direction = "East",
					keyframes = {
						{
							frame = "frame_14", duration = 0.1, x = -12, y = -17,
							hitboxes = {
								["weak"] = { rect = { x = -5, y = -14, w = 12, h = 15 } },
							},
						},
					},
				},
				{
					direction = "North",
					keyframes = {
						{
							frame = "frame_15", duration = 0.1, x = -14, y = -20,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -14, w = 15, h = 15 } },
							},
						},
					},
				},
				{
					direction = "West",
					keyframes = {
						{
							frame = "frame_13", duration = 0.1, x = -10, y = -17,
							hitboxes = {
								["weak"] = { rect = { x = -8, y = -13, w = 15, h = 14 } },
							},
						},
					},
				},
				{
					direction = "South",
					keyframes = {
						{
							frame = "frame_12", duration = 0.1, x = -14, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -13, w = 14, h = 15 } },
							},
						},
					},
				},
			},
		},
		["knockback"] = {
			loop = true,
			sequences = {
				{
					direction = "North",
					keyframes = {
						{
							frame = "frame_16", duration = 0.1, x = -24, y = -19,
							hitboxes = {
								["weak"] = { rect = { x = -10, y = -14, w = 17, h = 14 } },
							},
						},
					},
				},
			},
		},
		["smashed"] = {
			loop = true,
			sequences = {
				{
					direction = "North",
					keyframes = {
						{
							frame = "frame_17", duration = 0.1, x = -26, y = -9,
						},
					},
				},
			},
		},
		["walk"] = {
			loop = true,
			sequences = {
				{
					direction = "East",
					keyframes = {
						{
							frame = "frame_23", duration = 0.15, x = -17, y = -18,
						},
						{
							frame = "frame_14", duration = 0.15, x = -12, y = -17,
						},
						{
							frame = "frame_22", duration = 0.15, x = -12, y = -18,
						},
						{
							frame = "frame_14", duration = 0.15, x = -12, y = -17,
						},
					},
				},
				{
					direction = "North",
					keyframes = {
						{
							frame = "frame_24", duration = 0.15, x = -12, y = -20,
						},
						{
							frame = "frame_15", duration = 0.15, x = -14, y = -21,
						},
						{
							frame = "frame_25", duration = 0.15, x = -10, y = -18,
						},
						{
							frame = "frame_15", duration = 0.15, x = -14, y = -21,
						},
					},
				},
				{
					direction = "West",
					keyframes = {
						{
							frame = "frame_21", duration = 0.15, x = -11, y = -18,
						},
						{
							frame = "frame_13", duration = 0.15, x = -10, y = -17,
						},
						{
							frame = "frame_20", duration = 0.15, x = -16, y = -18,
						},
						{
							frame = "frame_13", duration = 0.15, x = -10, y = -17,
						},
					},
				},
				{
					direction = "South",
					keyframes = {
						{
							frame = "frame_18", duration = 0.15, x = -11, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -13, w = 15, h = 15 } },
							},
						},
						{
							frame = "frame_12", duration = 0.15, x = -14, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -13, w = 14, h = 15 } },
							},
						},
						{
							frame = "frame_19", duration = 0.15, x = -22, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -8, y = -14, w = 15, h = 16 } },
							},
						},
						{
							frame = "frame_12", duration = 0.15, x = -14, y = -18,
							hitboxes = {
								["weak"] = { rect = { x = -7, y = -13, w = 14, h = 15 } },
							},
						},
					},
				},
			},
		},
	},
};
