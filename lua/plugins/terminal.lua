return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{ "<M-f>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
		{ "<M-h>", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
		{ "<M-v>", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Toggle vertical terminal" },
	},
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 5,
				width = math.floor(vim.o.columns * 0.9),
				height = math.floor(vim.o.lines * 0.8),
			},
		})

		-- Function to dynamically resize float terminals on window resize
		local function resize_float_terms()
			local Terminal = require("toggleterm.terminal").Terminal
			for _, term in pairs(require("toggleterm.terminal").get_all()) do
				if term.direction == "float" and term.window then
					vim.api.nvim_win_set_config(term.window, {
						relative = "editor",
						border = "curved",
						width = math.floor(vim.o.columns * 0.9),
						height = math.floor(vim.o.lines * 0.8),
						row = math.floor((vim.o.lines - vim.o.lines * 0.8) / 2),
						col = math.floor((vim.o.columns - vim.o.columns * 0.9) / 2),
					})
				end
			end
		end

		-- Autocmd to resize terminals when Neovim window size changes
		vim.api.nvim_create_autocmd("VimResized", {
			callback = resize_float_terms,
		})

		-- Optional: Custom terminal for lazygit
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap(
			"n",
			"<leader>tg",
			"<cmd>lua _LAZYGIT_TOGGLE()<CR>",
			{ noremap = true, silent = true, desc = "Toggle Lazygit" }
		)
	end,
}
