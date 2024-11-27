-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  {
    command = "prettierd",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css", "scss", "html", "yaml",
      "markdown", "json", "jsonc" },
  },
  {
    command = "sql-formatter",
    filetypes = { "sql" },
  }
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8",   filetypes = { "python" } },
  { command = "eslint",   filetypes = { "typescript" } },
  { command = "sqlfluff", filetypes = { "sql" } },
  { command = "codespell" }
}

-- additional lsps
local lspconfig = require "lspconfig"
lspconfig.sqls.setup {
  cmd = { "sqls" },
  filetypes = { "sql" },
  root_dir = lspconfig.util.root_pattern(".git"),
}
