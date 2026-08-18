return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 1, -- 0 = filename, 1 = relative path, 2 = absolute path
		}

		local hide_in_width = function()
			return vim.api.nvim_win_get_width(0) > 80
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = {
				error = " ",
				warn = " ",
				info = " ",
				hint = " ",
			},
			colored = true,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = {
				added = " ",
				modified = " ",
				removed = " ",
			},
			cond = hide_in_width,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto", -- dynamically syncs with Catppuccin
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha", "dashboard", "neo-tree", "NvimTree" },
					winbar = {},
				},
				always_divide_middle = true,
				globalstatus = vim.o.laststatus == 3,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filename },
				lualine_x = {
					diagnostics,
					diff,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive", "neo-tree", "lazy", "mason" },
		})
	end,
}
