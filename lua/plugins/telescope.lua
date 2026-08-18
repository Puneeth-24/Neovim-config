return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
		{ "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect Telescope" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
		{ "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					})
				)
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local actions = require("telescope.actions")
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-l>"] = actions.select_default,
						["<C-u>"] = false, -- allow clearing prompt with ctrl+u
					},
				},
				file_ignore_patterns = {
					"^.git/",
					"^node_modules/",
					"^.venv/",
					"^target/",
					"^dist/",
					"^build/",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = false,
				},
				live_grep = {
					additional_args = function()
						return { "--hidden" }
					end,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Load extensions safely
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")
	end,
}
