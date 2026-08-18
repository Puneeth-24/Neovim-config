return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		local catppuccin = require("catppuccin")

		local config_opts = {
			flavour = "auto", -- "latte", "frappe", "macchiato", "mocha"
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mason = true,
				telescope = { enabled = true },
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		}

		catppuccin.setup(config_opts)
		vim.cmd.colorscheme("catppuccin")

		-- Toggle Transparency Keymap
		local is_transparent = config_opts.transparent_background

		local function toggle_transparency()
			is_transparent = not is_transparent
			config_opts.transparent_background = is_transparent
			catppuccin.setup(config_opts)
			catppuccin.compile()
			vim.cmd.colorscheme("catppuccin")
			vim.notify("Catppuccin transparency: " .. (is_transparent and "ON" or "OFF"), vim.log.levels.INFO)
		end

		vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle background transparency" })
	end,
}
