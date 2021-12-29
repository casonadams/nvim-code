local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  return
end

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
