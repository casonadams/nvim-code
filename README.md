# nvim-code

VSCode alternative that is blazing fast

## quick start

```sh
git clone git@github.com:casonadams/nvim-code.git ~/.config/nvim
```

Open `nvim` and install and update plugins with `:PackerSync` Close and reopen
`nvim` to install `treesitter` settings

## Lazy loading

- Note this setup is configured for lazy loading of plugins. Meaning plugins
  wont be used unless the filetype matches with settings in the `after/ftplugin`
  dir. It has its cons opening a `markdown` file and then `:e rustfile` won't
  enable lsp for rust file. To get around this put all
  `after/ftplugin/ config into `lua/_custom.lua`and require that in`init.lua`

```lua
local null_ls = require("null-ls")

local sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.shfmt.with({
		extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
	}),

	null_ls.builtins.diagnostics.shellcheck,
	null_ls.builtins.diagnostics.markdownlint,
	null_ls.builtins.diagnostics.eslint,
}

null_ls.setup({ sources = sources })
```

## Install language servers

`:LspInstallInfo`

- `i` installs server
- `u` updates server
- `?` toggles commands

## Navigation

| Key Combo               | Description               |
| ----------------------- | ------------------------- |
| Normal mode `Space`     | Displays all key mappings |
| Normal mode `H`         | Previous Buffer           |
| Normal mode `L`         | Next Buffer               |
| Normal mode `Ctrl + h`  | Window left               |
| Normal mode `Ctrl + j`  | Window down               |
| Normal mode `Ctrl + k`  | Window up                 |
| Normal mode `Ctrl + l`  | Window right              |
| Normal mode `tab`       | Tab next                  |
| Normal mode `Shift tab` | Tab previous              |
| Normal mode `gd`        | Go to def                 |
| Normal mode `gl`        | Show line diagnostics     |
| Normal mode `K`         | Show doc hover            |
| Normal mode `Space lf`  | Format command            |
| Normal mode `Space lr`  | Rename command            |
