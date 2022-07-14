local utils_ok, utils = pcall(require, "utils")
if not utils_ok then
  return
end

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
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

local border = {
  { "╭", "NormalFloat" },
  { "─", "NormalFloat" },
  { "╮", "NormalFloat" },
  { "│", "NormalFloat" },
  { "╯", "NormalFloat" },
  { "─", "NormalFloat" },
  { "╰", "NormalFloat" },
  { "│", "NormalFloat" },
}

-- round some of the window borders
win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = border
  return opts
end

-- completion setup
cmp.setup({
  snippet = {
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body)
      require("luasnip").lsp_expand(args.body)
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
    { name = "buffer" },
    { name = "path" },
    -- { name = "vsnip" },
    { name = "luasnip" },
    -- { name = "ultisnips" },
  },
})

-- function to attach completion when setting up lsp
local on_attach = function(client)
  -- utils.bufmap("n", "ga", "lua vim.lsp.buf.code_action()")
  -- utils.bufmap("n", "gd", "lua vim.lsp.buf.definition()")
  -- utils.bufmap("n", "gr", "lua vim.lsp.buf.references()")
  -- utils.bufmap("n", "K", "lua vim.lsp.buf.hover()")
  -- utils.bufmap("n", "gl", "lua vim.lsp.diagnostic.show_line_diagnostics()")
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  }),
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

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
    handlers = handlers,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }
  server:setup(opts)
end)

-- diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  float = {
    border = border,
    source = "always",
  },
  severity_sort = true,
  signs = false,
  update_in_insert = false,
})
