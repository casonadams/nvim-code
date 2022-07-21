local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  return
end

telescope.load_extension("terraform_doc")

telescope.setup({
  defaults = {
    border = false,
    layout_strategy = "bottom_pane",
    layout_config = {
      height = 0.33,
      width = 1.00,
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      },
    },
    -- path_display = { "shorten" },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<Tab>"] = "move_selection_next",
        ["<S-Tab>"] = "move_selection_previous",
      },
    },
  },
})
