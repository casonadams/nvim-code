local cmp = require("cmp")
local lsp_status = require("lsp-status")

local win = require("lspconfig.ui.windows")
local _default_opts = win.default_opts

win.default_opts = function(options)
	local opts = _default_opts(options)
	opts.border = "rounded"
	return opts
end

-- statusline progress setup
lsp_status.config({
	current_function = false,
	show_filename = false,
	diagnostics = false,
	status_symbol = "",
	select_symbol = nil,
	update_interval = 200,
})

-- completion setup
cmp.setup({
	snippet = {
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		-- { name = "ultisnips" },
		-- { name = "vsnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- helper function for mappings
local m = function(mode, key, result)
	vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd> " .. result .. "<cr>", {
		noremap = true,
		silent = true,
	})
end

-- function to attach completion when setting up lsp
local on_attach = function(client)
	lsp_status.register_progress()
	lsp_status.on_attach(client)

	-- Mappings.
	m("n", "ga", "lua vim.lsp.buf.code_action()")
	m("n", "gD", "lua vim.lsp.buf.declaration()")
	m("n", "gd", "lua vim.lsp.buf.definition()")
	m("n", "ge", "lua vim.lsp.diagnostic.goto_next()")
	m("n", "gE", "lua vim.lsp.diagnostic.goto_prev()")
	m("n", "gi", "lua vim.lsp.buf.implementation()")
	m("n", "gr", "lua vim.lsp.buf.references()")
	m("n", "K", "lua vim.lsp.buf.hover()")
	-- m("n", "<space>rn", "lua vim.lsp.buf.rename()")
	m("n", "gl", "lua vim.lsp.diagnostic.show_line_diagnostics()")
	-- m("n", "<space>f", "lua vim.lsp.buf.formatting()")
end

-- setup lsp installer
local lsp_installer = require("nvim-lsp-installer")
-- Provide settings first!
lsp_installer.settings({
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = on_attach,
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		flags = {
			debounce_text_changes = 150,
		},
	}
	server:setup(opts)
end)

-- lsp settings
require("nlspsettings").setup()

-- diagnostics
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	float = {
		source = "always",
	},
	severity_sort = true,
	--[[ virtual_text = {
      prefix = "»",
      spacing = 4,
    }, ]]
	signs = true,
	update_in_insert = false,
})
