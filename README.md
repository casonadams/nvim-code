# nvim-code

VSCode alternative that is blazing fast

## quick start

```sh
git clone git@github.com:casonadams/nvim-code.git ~/.config/nvim
```

Open `nvim` and install and update plugins with `:PackerSync` Close and reopen
`nvim` to install `treesitter` settings

## colorscheme

[alacritty-shell](https://github.com/casonadams/alacritty-shell) setups up addional
colors in the terminal. Index 18 is used for the statusline background, and
Index 16 is used for orange in some color schemes for `walh`. This can get setup
using [alacritty](https://github.com/alacritty/alacritty),
[256 colorscheme](https://github.com/aarowill/base16-alacritty/tree/master/colors)
can be copy pasted.

### example

```yml
# Base16 Gruvbox dark, medium 256 - alacritty color config
# Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
colors:
  # Default colors
  primary:
    background: "0x282828"
    foreground: "0xd5c4a1"

  # Colors the cursor will use if `custom_cursor_colors` is true
  cursor:
    text: "0x282828"
    cursor: "0xd5c4a1"

  # Normal colors
  normal:
    black: "0x282828"
    red: "0xfb4934"
    green: "0xb8bb26"
    yellow: "0xfabd2f"
    blue: "0x83a598"
    magenta: "0xd3869b"
    cyan: "0x8ec07c"
    white: "0xd5c4a1"

  # Bright colors
  bright:
    black: "0x665c54"
    red: "0xfb4934"
    green: "0xb8bb26"
    yellow: "0xfabd2f"
    blue: "0x83a598"
    magenta: "0xd3869b"
    cyan: "0x8ec07c"
    white: "0xfbf1c7"

  indexed_colors:
    - { index: 16, color: "0xfe8019" }
    - { index: 17, color: "0xd65d0e" }
    - { index: 18, color: "0x3c3836" }
    - { index: 19, color: "0x504945" }
    - { index: 20, color: "0xbdae93" }
    - { index: 21, color: "0xebdbb2" }
```

## Lazy loading

- Note this setup is configured for lazy loading of plugins. Meaning plugins
  won't be used unless the filetype matches with settings in the
  `after/ftplugin` dir. It has its cons opening a `markdown` file and then
  `:e rustfile` won't enable lsp for rust file. To get around this put all
  null-ls config in `after/ftplugin/` config into `lua/_null-ls.lua` and require
  that in`init.lua`

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
