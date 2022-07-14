local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_Bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end
return packer.startup(function()
  use({
    "wbthomason/packer.nvim",
    "dstein64/vim-startuptime",
    "lewis6991/impatient.nvim",

    "casonadams/walh",
    "b3nj5m1n/kommentary",
    "folke/which-key.nvim",

    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",

    "jose-elias-alvarez/null-ls.nvim",
    "neovim/nvim-lspconfig",
    "tamago324/nlsp-settings.nvim",
    "williamboman/nvim-lsp-installer",

    "kyazdani42/nvim-web-devicons",

    "nvim-treesitter/nvim-treesitter",
    "pacha/vem-tabline",
    "mhinz/vim-sayonara",
  })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "ANGkeith/telescope-terraform-doc.nvim" },
    },
  })
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        timer = {
          spinner_rate = 40,
          fidget_decay = 0,
          task_decay = 0,
        },
      })
    end,
  })
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        numhl = true,
        yadm = { enable = false },
      })
    end,
  })
  use({
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      })
    end,
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  })
  use({
    "ur4ltz/surround.nvim",
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end,
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if Packer_Bootstrap then
    require("packer").sync()
  end
end)
