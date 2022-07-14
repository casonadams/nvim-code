local api = vim.api

api.nvim_command("autocmd TermOpen * startinsert")
api.nvim_command("autocmd TermOpen * setlocal nonumber")
api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

api.nvim_command("autocmd  WinLeave,TabLeave * if exists('w:zoomed') | silent! call WindowUnzoom() | endif")

local result = vim.api.nvim_exec(
  [[
function! WindowUnzoom()
  if !exists('w:zoomed')
    echo 'Could not unzoom'
  else
    unlet w:zoomed
    wincmd =
  endif
endfunction

function! WindowZoom()
  if exists('w:zoomed')
    call WindowUnzoom()
  else
    let w:zoomed = 'TRUE'
    wincmd |
    wincmd _
  endif
endfunction
]],
  true
)
