return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = { winblend = 0 },
				},
			},
		},
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Diagnostic display configuration
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
			},
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},
		})

		-- Autocommand for active LSP buffers
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Navigation / Telescope integrations
				local builtin = require("telescope.builtin")
				map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
				map("gr", builtin.lsp_references, "[G]oto [R]eferences")
				map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Actions & Hover
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Document highlight on hover
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Inlay hints toggle
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Default client capabilities with cmp support
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Language server configurations
		local servers = {
			ts_ls = {},
			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = { enable = false },
					},
				},
			},
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
			},
		}

		-- Setup Mason tools
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Setup language servers via mason-lspconfig
		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					lspconfig[server_name].setup(server)
				end,
			},
		})
	end,
}
