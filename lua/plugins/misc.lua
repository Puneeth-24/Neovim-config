-- Standalone lightweight utilities and tools
return {
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
		cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
			{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
		},
		dependencies = {
			-- GitHub integration for vim-fugitive (GBrowse)
			"tpope/vim-rhubarb",
		},
	},

	{
		-- Popup keybind hints (v3+)
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "classic",
			spec = {
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Document" },
				{ "<leader>g", group = "Git" },
				{ "<leader>r", group = "Rename" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>w", group = "Workspace" },
			},
		},
	},

	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			-- Automatically add parentheses after selecting a function/method in nvim-cmp
			local cmp_status_ok, cmp = pcall(require, "cmp")
			if cmp_status_ok then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},

	{
		-- Highlight and search TODO, FIX, HACK, WARN in comments
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODO comments" },
		},
	},

	{
		-- Actively maintained high-performance color highlighter
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				AARRGGBB = false,
				rgb_fn = true,
				hsl_fn = true,
				css = false,
				css_fn = false,
				mode = "background", -- "background" | "foreground" | "virtualtext"
				tailwind = true,
				sass = { enable = false },
				virtualtext = "■",
			},
		},
	},
}
