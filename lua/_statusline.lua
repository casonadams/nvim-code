local api = vim.api
local o = vim.o

local utils_ok, utils = pcall(require, "utils")
if not utils_ok then
  return
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local colors = {
  background = utils.extract_highlight_colors("StatusLine", "bg", 247),
  foreground = utils.extract_highlight_colors("StatusLine", "fg", 7),
  red = utils.extract_highlight_colors("LspDiagnosticsDefaultError", "fg", 1),
  green = utils.extract_highlight_colors("LspDiagnosticsDefaultError", "fg", 2),
  yellow = utils.extract_highlight_colors("LspDiagnosticsDefaultHint", "fg", 3),
  blue = utils.extract_highlight_colors("LspDiagnosticsDefaultInformation", "fg", 4),
  orange = utils.extract_highlight_colors("LspDiagnosticsDefaultWarning", "fg", 208),
  grey = utils.extract_highlight_colors("StatusLineNC", "fg", 8),
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
    a = { bg = colors.background, fg = colors.grey },
    b = { bg = colors.background, fg = colors.grey },
    c = { bg = colors.background, fg = colors.grey },
  },
}

local components = {
  buffers = { "buffers", mode = 0, show_filename_only = true, max_length = o.columns },
  encoding = { "o:encoding", fmt = string.upper },
  filename = { "filename", path = 1 },
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
    sources = { "nvim_diagnostic", "coc" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    diagnostics_color = {
      error = { fg = colors.red },
      warn = { fg = colors.yellow },
      info = { fg = colors.blue },
      hint = { fg = colors.grey },
    },
  },
  branch = {
    "b:gitsigns_head",
    icons_enabled = true,
    icon = "",
  },
  diff = {
    "diff",
    source = diff_source,
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    color = {},
  },
  filetype = { "filetype", icon_only = true, colored = false },
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
      components.diff,
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      components.diagnostics,
      components.treesitter,
      -- components.branch,
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
