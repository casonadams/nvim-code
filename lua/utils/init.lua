local utils = {}
local api = vim.api
local fn = vim.fn

function utils.bufmap(mode, key, result)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd> " .. result .. "<cr>", opts)
end

function utils.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function utils.extract_highlight_colors(color_group, scope, cterm_color)
  if fn.hlexists(color_group) == 0 then
    return cterm_color
  end
  local color = api.nvim_get_hl_by_name(color_group, true)
  if color.background ~= nil then
    color.bg = string.format("#%06x", color.background)
    color.background = nil
  else
    return cterm_color
  end

  if color.foreground ~= nil then
    color.fg = string.format("#%06x", color.foreground)
    color.foreground = nil
  else
    return cterm_color
  end

  if color.reverse then
    if scope == "bg" then
      scope = "fg"
    else
      scope = "bg"
    end
  end
  if scope then
    return color[scope]
  end
  return color
end

return utils
