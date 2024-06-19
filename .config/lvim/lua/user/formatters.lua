-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  {
    command = "prettierd",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css", "scss", "html", "yaml",
      "markdown", "json", "jsonc" },
  },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8",   filetypes = { "python" } },
  { command = "eslint_d", filetypes = { "typescript" } },
  { command = "codespell" }
}
