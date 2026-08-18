return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "▏",
			tab_char = "▏",
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			show_exact_scope = false,
		},
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"NvimTree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"TelescopePrompt",
				"TelescopeResults",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},
}
