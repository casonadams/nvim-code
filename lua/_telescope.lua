local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
  return
end

telescope.setup({
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

trouble.setup({
  icons = false,
})
