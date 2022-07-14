local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  return
end

local command_resolver = require("null-ls.helpers.command_resolver")

local sources = {
  null_ls.builtins.formatting.stylua,

  -- python
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.diagnostics.flake8,

  -- sh
  null_ls.builtins.formatting.shfmt.with({
    extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  }),
  null_ls.builtins.diagnostics.shellcheck,

  -- markdown
  null_ls.builtins.diagnostics.markdownlint,
  null_ls.builtins.formatting.markdownlint,

  -- javascript
  null_ls.builtins.formatting.eslint.with({
    dynamic_command = function(params)
      return command_resolver.from_yarn_pnp(params)
        or command_resolver.from_node_modules(params)
        or vim.fn.executable(params.command) == 1 and params.command
    end,
  }),
  null_ls.builtins.code_actions.eslint.with({
    dynamic_command = function(params)
      return command_resolver.from_yarn_pnp(params)
        or command_resolver.from_node_modules(params)
        or vim.fn.executable(params.command) == 1 and params.command
    end,
  }),
  null_ls.builtins.diagnostics.eslint.with({
    dynamic_command = function(params)
      return command_resolver.from_yarn_pnp(params)
        or command_resolver.from_node_modules(params)
        or vim.fn.executable(params.command) == 1 and params.command
    end,
  }),

  null_ls.builtins.completion.spell,

  -- terraform
  null_ls.builtins.formatting.terraform_fmt,

  null_ls.builtins.diagnostics.rubocop,
}

null_ls.setup({ sources = sources })
