return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Mason integration to ensure binaries are installed
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"eslint_d",
				"shfmt",
				"checkmake",
				"clang-format",
				"stylua",
				"ruff",
			},
			automatic_installation = true,
		})

		local sources = {
			-- Diagnostics / Linters
			diagnostics.checkmake,
			require("none-ls.diagnostics.eslint_d"),

			-- Formatters
			formatting.prettier.with({
				filetypes = { "html", "json", "yaml", "markdown", "javascript", "typescript", "typescriptreact" },
			}),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,

			-- Python (Ruff from none-ls-extras)
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),

			-- C / C++
			formatting.clang_format.with({
				filetypes = { "c", "cpp", "objc", "objcpp" },
				extra_args = { "--style=LLVM" },
			}),
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.id == client.id
								end,
							})
						end,
					})
				end
			end,
		})
	end,
}
