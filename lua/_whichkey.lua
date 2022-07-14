local utils_ok, utils = pcall(require, "utils")
if not utils_ok then
  return
end

local which_key = {
  setup = {
    plugins = {
      marks = true,
      registers = true,
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
      spelling = { enabled = true, suggestions = 20 },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    window = {
      border = "none", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 0, 0, 1, 0 },
      padding = { 1, 1, 1, 1 },
    },
    layout = {
      height = { min = 1, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "center",
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    show_help = true,
  },
  opts = {
    mode = "n",
    prefix = "",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  },
  -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
  -- see https://neovim.io/doc/user/map.html#:map-cmd
  mappings = {
    ["<leader>f"] = { utils.find_project_files, "Find File" },
    -- ["<leader>e"] = { ":Lexplore! 33<CR>", "File Browser" },
    ["<leader>e"] = { ":NvimTreeToggle<CR>", "File Browser" },
    ["<leader>h"] = { ":nohlsearch<CR>", "No Highlight" },
    -- ["H"] = { ":bp<CR>", "Buffer Previous" },
    -- ["L"] = { ":bn<CR>", "Buffer Next" },
    ["H"] = { "<Plug>vem_prev_buffer-", "Buffer Previous" },
    ["L"] = { "<Plug>vem_next_buffer-", "Buffer Next" },
    -- ["<leader>x"] = { "<Plug>vem_delete_buffer-", "Buffer Delete" },
    ["<leader>x"] = { ":Sayonara!<cr>", "Buffer Delete" },
    ["<leader>z"] = { ":call WindowZoom()<cr>", "Toggle Zoom" },
    ["<leader>o"] = { ":wincmd w<cr>", "Next window" },
    ["gd"] = { ":lua vim.lsp.buf.definition()<cr>", "jumpDefinition" },
    ["ga"] = { ":lua vim.lsp.buf.code_action()<cr>", "diagnosticInfo" },
    ["K"] = { ":lua vim.lsp.buf.hover()<cr>", "doHover" },
    ["gl"] = { ":lua vim.diagnostic.open_float()<cr>", "diagnosticInfo" },

    ["<leader>t"] = {
      name = "Terminal",
      ["%"] = { ":vsplit term://${SHELL}<CR>", "Open TERM right" },
      ['"'] = { ":split term://${SHELL}<CR>", "Open TERM down" },
    },
    ["<leader>b"] = {
      name = "Buffers",
      l = { ":Telescope buffers<CR>", "List Buffers" },
      b = { ":b#<cr>", "Last" },
      d = { ":bd<cr>", "Delete" },
      f = { ":Telescope buffers <cr>", "Find" },
      n = { ":bn<cr>", "Next" },
      p = { ":bp<cr>", "Previous" },
    },
    ["<leader>l"] = {
      name = "LSP",
      a = { ":lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      -- a = { ":Telescope lsp_code_actions<cr>", "Code Action" },
      d = {
        ":Telescope lsp_document_diagnostics<cr>",
        "Document Diagnostics",
      },
      w = {
        ":Telescope diagnostics<cr>",
        "Workspace Diagnostics",
      },
      f = { ":lua vim.lsp.buf.formatting()<cr>", "Format" },
      i = { ":LspInfo<cr>", "Info" },
      I = { ":LspInstallInfo<cr>", "Installer Info" },
      r = { ":lua vim.lsp.buf.rename()<cr>", "Rename" },
    },

    ["<leader>s"] = {
      name = "Search",
      b = { ":Telescope git_branches <cr>", "Checkout branch" },
      c = { ":Telescope colorscheme <cr>", "Colorscheme" },
      C = { ":Telescope commands <cr>", "Commands" },
      f = { ":Telescope find_files <cr>", "Find File" },
      h = { ":Telescope help_tags <cr>", "Find Help" },
      j = { ":Telescope jumplist <cr>", "Jumplist" },
      k = { ":Telescope keymaps <cr>", "Keymaps" },
      M = { ":Telescope man_pages <cr>", "Man Pages" },
      r = { ":Telescope oldfiles <cr>", "Open Recent File" },
      R = { ":Telescope registers <cr>", "Registers" },
      t = { ":Telescope live_grep <cr>", "Text" },
      n = { ":Telescope live_grep search_dirs={os.getenv('NOTES')} <cr>", "Notes" },
      p = {
        ":lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
        "Colorscheme with Preview",
      },
    },
  },
}

utils.map("t", "<esc>", "<C-\\><C-n>")
-- utils.map("i", "<Tab>", 'v:lua.smart_tab("down")', { expr = true })
-- utils.map("i", "<S-Tab>", 'v:lua.smart_tab("up")', { expr = true })
-- utils.map("i", "<cr>", "v:lua.smart_enter()", { expr = true })

local wk = require("which-key")
wk.setup(which_key.setup)

local opts = which_key.opts
local mappings = which_key.mappings

wk.register(mappings, opts)

if which_key.on_config_done then
  which_key.on_config_done(wk)
end
