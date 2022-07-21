local utils = {}
local api = vim.api
local fn = vim.fn

local builtin_ok, builtin = pcall(require, "telescope.builtin")
if not builtin_ok then
	return
end

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.smart_tab(direction)
	if direction == "down" then
		return vim.fn.pumvisible() == 1 and t("<C-n>") or t("<Tab>")
	else
		return vim.fn.pumvisible() == 1 and t("<C-p>") or t("<S-Tab>")
	end
end
function _G.smart_enter()
	return vim.fn.pumvisible() == 1 and t("<C-y>") or t("<cr>")
end

function utils.smart_tab(direction)
	if direction == "down" then
		return vim.fn.pumvisible() == 1 and t("<C-n>") or t("<Tab>")
	else
		return vim.fn.pumvisible() == 1 and t("<C-p>") or t("<S-Tab>")
	end
end
function utils.smart_enter()
	return vim.fn.pumvisible() == 1 and t("<C-y>") or t("<cr>")
end

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

function utils.find_project_files()
	local ok = pcall(builtin.git_files)

	if not ok then
		builtin.find_files()
	end
end

return utils
