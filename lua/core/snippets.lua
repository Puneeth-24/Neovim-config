-- core/snippets.lua (UI appearance, diagnostics, and autocommands)

-- Lower LSP semantic token priority below Treesitter (100) to prevent color overrides
if vim.hl and vim.hl.priorities then
	vim.hl.priorities.semantic_tokens = 95
end

-- Configure diagnostics globally
vim.diagnostic.config({
	underline = false,
	update_in_insert = false, -- false avoids distracting flicker while typing
	severity_sort = true,
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
		format = function(diagnostic)
			local code = diagnostic.code and string.format("[%s] ", diagnostic.code) or ""
			return string.format("%s%s", code, diagnostic.message)
		end,
	},
	float = {
		border = "rounded",
		source = "always",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
		},
	},
})

-- Ensure diagnostic virtual text background remains transparent across theme changes
local diag_group = vim.api.nvim_create_augroup("DiagnosticHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = diag_group,
	callback = function()
		local hl_groups = {
			"DiagnosticVirtualTextError",
			"DiagnosticVirtualTextWarn",
			"DiagnosticVirtualTextInfo",
			"DiagnosticVirtualTextHint",
		}
		for _, name in ipairs(hl_groups) do
			vim.api.nvim_set_hl(0, name, { bg = "none" })
		end
	end,
})

-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})
