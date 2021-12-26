require("telescope").setup({
	defaults = {
		border = true,
		layout_strategy = "bottom_pane",
		layout_config = {
			height = 0.30,
			width = 1.00,
		},
		-- path_display = { "shorten" },
		sorting_strategy = "ascending",
	},
})

require("trouble").setup({
  icons=false
})
