local utils_ok, utils = pcall(require, "utils")
if not utils_ok then
  return
end

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  return
end

local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
if not lsp_status_ok then
  return
end

local win_ok, win = pcall(require, "lspconfig.ui.windows")
if not win_ok then
  return
end

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lsp_installer_ok then
  return
end

local nlspsettings_ok, nlspsettings = pcall(require, "nlspsettings")
if not nlspsettings_ok then
  return
end

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
  return
end

local _default_opts = win.default_opts

nlspsettings.setup()

-- round some of the window borders
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

-- function to attach completion when setting up lsp
local on_attach = function(client)
  lsp_status.register_progress()
  lsp_status.on_attach(client)
  utils.bufmap("n", "ga", "lua vim.lsp.buf.code_action()")
  utils.bufmap("n", "gD", "lua vim.lsp.buf.declaration()")
  utils.bufmap("n", "gd", "lua vim.lsp.buf.definition()")
  utils.bufmap("n", "ge", "lua vim.lsp.diagnostic.goto_next()")
  utils.bufmap("n", "gE", "lua vim.lsp.diagnostic.goto_prev()")
  utils.bufmap("n", "gi", "lua vim.lsp.buf.implementation()")
  utils.bufmap("n", "gr", "lua vim.lsp.buf.references()")
  utils.bufmap("n", "K", "lua vim.lsp.buf.hover()")
  utils.bufmap("n", "gl", "lua vim.lsp.diagnostic.show_line_diagnostics()")
end

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
    capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = { debounce_text_changes = 150 },
  }
  server:setup(opts)
end)

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
