local api = vim.api

local utils_ok, utils = pcall(require, "utils")
if not utils_ok then
  return
end

local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
if not lsp_status_ok then
  return
end

local function lsp_progress()
  return lsp_status.status()
end

local colors = {
  background = utils.extract_highlight_colors("StatusLine", "bg", 18),
  foreground = utils.extract_highlight_colors("StatusLine", "fg", 7),
  red = utils.extract_highlight_colors("LspDiagnosticsDefaultError", "fg", 1),
  yellow = utils.extract_highlight_colors("LspDiagnosticsDefaultHint", "fg", 3),
  blue = utils.extract_highlight_colors("LspDiagnosticsDefaultInformation", "fg", 4),
  orange = utils.extract_highlight_colors("LspDiagnosticsDefaultWarning", "fg", 6),
  gray = utils.extract_highlight_colors("StatusLineNC", "fg", 8),
}

local custom_theme = {
  normal = {
    a = { bg = colors.foreground, fg = colors.background },
    b = { bg = colors.background, fg = colors.foreground },
    c = { bg = colors.background, fg = colors.foreground },
  },
  insert = {
    a = { bg = colors.blue, fg = colors.background },
    b = { bg = colors.background, fg = colors.blue },
    c = { bg = colors.background, fg = colors.foreground },
  },
  visual = {
    a = { bg = colors.yellow, fg = colors.background },
    b = { bg = colors.background, fg = colors.yellow },
    c = { bg = colors.background, fg = colors.foreground },
  },
  replace = {
    a = { bg = colors.red, fg = colors.background },
    b = { bg = colors.background, fg = colors.red },
    c = { bg = colors.background, fg = colors.foreground },
  },
  command = {
    a = { bg = colors.orange, fg = colors.background },
    b = { bg = colors.background, fg = colors.orange },
    c = { bg = colors.background, fg = colors.foreground },
  },
  inactive = {
    a = { bg = colors.background, fg = colors.gray },
    b = { bg = colors.background, fg = colors.gray },
    c = { bg = colors.background, fg = colors.gray },
  },
}

local components = {
  buffers = { "buffers" },
  encoding = { "o:encoding", fmt = string.upper },
  filename = { "filename" },
  filetype = { "filetype" },
  location = { "location" },
  progress = { "progress" },
  tabs = { "tabs", mode = 0 },
  mode = {
    function()
      return " "
    end,
    padding = { left = 0, right = 0 },
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
  },
  treesitter = {
    function()
      local b = api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        return ""
      end
      return ""
    end,
  },
}

local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
  return
end

-- define how the statusline and tabline appear
lualine.setup({
  options = {
    theme = custom_theme,
    icons_enabled = false,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      components.filename,
    },
    lualine_c = {
      components.diff,
    },
    lualine_x = {
      lsp_progress,
      components.diagnostics,
    },
    lualine_y = {
      components.treesitter,
    },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {
      components.filename,
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = {},
    lualine_b = { components.buffers },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { components.tabs },
    lualine_z = {},
  },
  extensions = { "nvim-tree" },
})
