local cmp = require "cmp"

cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'copilot' },
    -- { name = 'tabnine' },
    { name = 'neorg' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
  })
})
