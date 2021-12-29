require("_options")
require("_plugins")
require("_lsp")
require("_treesitter")
require("_telescope")
require("_whichkey")
require("_null-ls")
require("_terminal")

vim.cmd("colorscheme walh-gruvbox")

-- important to import after colorscheme
require("_statusline")
