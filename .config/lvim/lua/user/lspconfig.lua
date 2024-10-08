require('lspconfig').clangd.setup {
  cmd = { "clangd", "--compile-commands-dir=." },
  root_dir = require('lspconfig').util.root_pattern(".ccls", "compile_commands.json", ".git"),
}
