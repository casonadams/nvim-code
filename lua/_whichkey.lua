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
      margin = { 1, 0, 1, 0 },
      padding = { 2, 2, 2, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    show_help = true,
  },

  opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  },
  vopts = {
    mode = "v",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  },
  -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
  -- see https://neovim.io/doc/user/map.html#:map-cmd
  vmappings = {},
  mappings = {
    ["c"] = { ":BufferClose!<CR>", "Close Buffer" },
    ["e"] = { ":Telescope file_browser <CR>", "File Browser" },
    ["f"] = { ":Telescope find_files <CR>", "Find File" },
    ["h"] = { ":nohlsearch<CR>", "No Highlight" },
    b = {
      name = "Buffers",
      l = { ":Telescope buffers<CR>", "List Buffers" },
      b = { ":b#<cr>", "Previous" },
      d = { ":bd<cr>", "Delete" },
      f = { ":Telescope buffers <cr>", "Find" },
      n = { ":bn<cr>", "Next" },
      p = { ":bp<cr>", "Previous" },
    },
    p = {
      name = "Packer",
      c = { ":PackerCompile<cr>", "Compile" },
      i = { ":PackerInstall<cr>", "Install" },
      r = { ":lua require('lvim.utils').reload_lv_config()<cr>", "Reload" },
      s = { ":PackerSync<cr>", "Sync" },
      S = { ":PackerStatus<cr>", "Status" },
      u = { ":PackerUpdate<cr>", "Update" },
    },
    l = {
      name = "LSP",
      a = { ":Telescope lsp_code_actions<cr>", "Code Action" },
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
    s = {
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
    T = {
      name = "Treesitter",
      i = { ":TSConfigInfo<cr>", "Info" },
    },
    t = {
      name = "Diagnostics",
      t = { "<cmd>TroubleToggle<cr>", "trouble" },
      w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
      d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
      q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
      l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
      r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
    },
  },
}

-- local function map(mode, lhs, rhs, opts)
--   local options = { noremap = true, silent = true }
--   if opts then
--     options = vim.tbl_extend("force", options, opts)
--   end
--   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
-- end

utils.map("n", "H", ":bp<CR>")
utils.map("n", "L", ":bn<CR>")
utils.map("n", "<tab>", ":tabnext<CR>")
utils.map("n", "<S-tab>", ":tabprevious<CR>")
utils.map("n", "<C-h>", ":wincmd h<CR>")
utils.map("n", "<C-j>", ":wincmd j<CR>")
utils.map("n", "<C-k>", ":wincmd k<CR>")
utils.map("n", "<C-l>", ":wincmd l<CR>")
utils.map("t", "<Esc>", "<C-\\><C-n>")

local wk = require("which-key")
wk.setup(which_key.setup)

local opts = which_key.opts
local vopts = which_key.vopts

local mappings = which_key.mappings
local vmappings = which_key.vmappings

wk.register(mappings, opts)
wk.register(vmappings, vopts)

if which_key.on_config_done then
  which_key.on_config_done(wk)
end
