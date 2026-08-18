return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
		{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
		{ "<leader>co", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
		{
			"<leader>x",
			function()
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[bufnr].buftype == "terminal" then
					vim.cmd.bdelete({ bang = true, args = { bufnr } })
				else
					local prev = vim.fn.bufnr("#")
					if prev > 0 and prev ~= bufnr and vim.fn.buflisted(prev) == 1 then
						vim.cmd.buffer(prev)
					else
						vim.cmd.bprevious()
					end
					-- Use nvim_buf_delete API instead of vim.cmd.bdelete
					if vim.api.nvim_buf_is_valid(bufnr) then
						vim.api.nvim_buf_delete(bufnr, { force = false })
					end
				end
			end,
			desc = "Close current buffer",
		},
	},
	config = function()
		local bufferline = require("bufferline")

		-- Safe check for catppuccin integration highlights
		local highlights = {}
		local ok, catppuccin_bufferline = pcall(require, "catppuccin.groups.integrations.bufferline")
		if ok then
			highlights = catppuccin_bufferline.get()
		end

		bufferline.setup({
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = function(n)
					vim.cmd("bdelete! " .. n)
				end,
				right_mouse_command = function(n)
					vim.cmd("bdelete! " .. n)
				end,
				buffer_close_icon = "✗",
				close_icon = "✗",
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30,
				tab_size = 21,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Explorer",
						highlight = "Directory",
						text_align = "left",
						padding = 1,
					},
					{
						filetype = "NvimTree",
						text = "Explorer",
						highlight = "Directory",
						text_align = "left",
						padding = 1,
					},
				},
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				persist_buffer_sort = true,
				separator_style = { "│", "│" },
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				show_tab_indicators = false,
				indicator = {
					style = "none",
				},
				icon_pinned = "󰐃",
				minimum_padding = 1,
				maximum_padding = 5,
				sort_by = "insert_at_end",
			},
			highlights = highlights,
		})
	end,
}
