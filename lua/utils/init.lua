local utils = {}
local api = vim.api
local fn = vim.fn

function utils.mapping(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd> " .. result .. "<cr>", {
    noremap = true,
    silent = true,
  })
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
