-- core/snippets.lua
-- Custom Neovim snippets for appearance, diagnostics, and yank highlighting

-- Use vim.schedule to ensure this runs after startup (avoids conflicts with LSP/Treesitter)
vim.schedule(function()
	--------------------------------------------------------------------------
	-- Prevent LSP from overwriting Treesitter color settings
	-- https://github.com/NvChad/NvChad/issues/1907
	--------------------------------------------------------------------------
	vim.hl.priorities.semantic_tokens = 95 -- Any number lower than 100 (Treesitter priority)

	--------------------------------------------------------------------------
	-- Configure the appearance of diagnostics
	--------------------------------------------------------------------------
	vim.diagnostic.config({
		-- Virtual text (inline diagnostic messages)
		virtual_text = {
			prefix = "●", -- Small dot before the message
			format = function(diagnostic)
				local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
				return string.format("%s %s", code, diagnostic.message)
			end,
		},
		underline = false, -- Disable underlines for a cleaner look
		update_in_insert = true, -- Update diagnostics while typing
		float = {
			source = true, -- Show the LSP source in floating diagnostics
		},
		-- Signs in the gutter
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = "󰌵 ",
			},
		},
		-- Make virtual text background transparent
		on_ready = function()
			vim.cmd("highlight DiagnosticVirtualText guibg=NONE")
		end,
	})

	--------------------------------------------------------------------------
	-- Highlight on yank (visual feedback when copying text)
	--------------------------------------------------------------------------
	local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.hl.on_yank()
		end,
		group = highlight_group,
		pattern = "*",
	})
end)
