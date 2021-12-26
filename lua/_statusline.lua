local lsp_status = require("lsp-status")

local function lsp_progress()
	return lsp_status.status()
end

local function extract_highlight_colors(color_group, scope)
	if vim.fn.hlexists(color_group) == 0 then
		return nil
	end
	local color = vim.api.nvim_get_hl_by_name(color_group, true)
	if color.background ~= nil then
		color.bg = string.format("#%06x", color.background)
		color.background = nil
	end
	if color.foreground ~= nil then
		color.fg = string.format("#%06x", color.foreground)
		color.foreground = nil
	end
	if scope then
		return color[scope]
	end
	return color
end

local colors = {
	gray = 8,
	red = 9,
	green = 10,
	yellow = 11,
	blue = 12,
	magenta = 13,
	cyan = 14,
	white = 15,
	background = extract_highlight_colors("StatusLine", "bg"),
	foreground = 7,
}

local custom_theme = {
	normal = {
		a = { bg = colors.foreground, fg = colors.background },
		b = { bg = colors.background, fg = colors.foreground },
		c = { bg = colors.background, fg = colors.foreground },
	},
	insert = {
		a = { bg = colors.cyan, fg = colors.background },
		b = { bg = colors.background, fg = colors.cyan },
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
		a = { bg = colors.magenta, fg = colors.background },
		b = { bg = colors.background, fg = colors.magenta },
		c = { bg = colors.background, fg = colors.foreground },
	},
	inactive = {
		a = { bg = colors.background, fg = colors.gray },
		b = { bg = colors.background, fg = colors.gray },
		c = { bg = colors.background, fg = colors.gray },
	},
}

local components = {
	mode = {
		function()
			return " "
		end,
		padding = { left = 0, right = 0 },
	},
	filename = {
		"filename",
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
	},
	treesitter = {
		function()
			local b = vim.api.nvim_get_current_buf()
			if next(vim.treesitter.highlighter.active[b]) then
				return ""
			end
			return ""
		end,
	},
	location = { "location" },
	progress = { "progress" },
	encoding = {
		"o:encoding",
		fmt = string.upper,
	},
	filetype = { "filetype" },
}

require("lualine").setup({
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
			"filename",
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {},
		lualine_b = { { "buffers" } },
		lualine_c = {},
		lualine_x = {},
		lualine_y = { { "tabs", mode = 0 } },
		lualine_z = {},
	},
	extensions = { "nvim-tree" },
})
