return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{ "<c-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
		{ "<M-f>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
		{ "<M-h>", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
		{ "<M-v>", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Toggle vertical terminal" },
		{
			"<leader>tg",
			function()
				local Terminal = require("toggleterm.terminal").Terminal
				local lazygit = Terminal:new({
					cmd = "lazygit",
					hidden = true,
					direction = "float",
					float_opts = {
						border = "curved",
					},
					on_open = function(term)
						vim.cmd("startinsert!")
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"n",
							"q",
							"<cmd>close<CR>",
							{ noremap = true, silent = true }
						)
					end,
				})
				lazygit:toggle()
			end,
			desc = "Toggle Lazygit",
		},
	},
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.4)
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
				winblend = 0,
				width = function()
					return math.floor(vim.o.columns * 0.85)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.8)
				end,
			},
		})

		-- Terminal navigation and keymaps
		local function set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = set_terminal_keymaps,
		})

		-- Resize floating terminals dynamically on window resize
		vim.api.nvim_create_autocmd("VimResized", {
			callback = function()
				local terms = require("toggleterm.terminal").get_all()
				for _, term in pairs(terms) do
					if term.direction == "float" and term.window and vim.api.nvim_win_is_valid(term.window) then
						local width = math.floor(vim.o.columns * 0.85)
						local height = math.floor(vim.o.lines * 0.8)
						vim.api.nvim_win_set_config(term.window, {
							relative = "editor",
							border = "curved",
							width = width,
							height = height,
							row = math.floor((vim.o.lines - height) / 2),
							col = math.floor((vim.o.columns - width) / 2),
						})
					end
				end
			end,
		})
	end,
}
