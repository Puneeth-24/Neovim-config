return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- ✅ Missing comma added here
	config = function()
		require("catppuccin").setup({
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			float = {
				transparent = false,
				solid = false,
			},
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
			lsp_styles = {
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
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			auto_integrations = false,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
		local is_transparent = true

		local function toggle_transparency()
			is_transparent = not is_transparent

			require("catppuccin").setup({
				transparent_background = is_transparent,
			})

			vim.cmd.colorscheme("catppuccin")

			vim.notify("Catppuccin transparency: " .. (is_transparent and "ON" or "OFF"), vim.log.levels.INFO)
		end

		-- 🗝️ Map the keybinding
		vim.keymap.set("n", "<leader>bg", toggle_transparency, { desc = "Toggle Catppuccin transparency" })
	end,
}
