-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
-- lvim.colorscheme = "lunar"
lvim.colorscheme = "ayu"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

vim.opt.relativenumber = true
vim.opt.shell = "/usr/bin/fish"
vim.opt.conceallevel = 2
vim.opt.foldlevel = 99
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
lvim.builtin.terminal.shell = "/usr/bin/fish"

-- transparent window
lvim.transparent_window = true;
vim.g.neovide_transparency = 0.5
vim.g.transparency = 0.5

-- lvim.plugin.tabnine.active = true
-- vim.opt.spell = true
-- vim.opt.spelllang = "en"

-- Check if g:neovide exists
if vim.g.neovide then
  -- Set the guifont for neovide
  vim.cmd([[set guifont=SauceCodePro\ Nerd\ Font:h12]])
  -- vim.cmd([[set guifont=monospace:h11]])
  -- Neovide cursor animation length
  vim.g.neovide_cursor_animation_length = 0.10
  -- Neovide cursor trail size
  vim.g.neovide_cursor_trail_size = 0.8
  -- Neovide cursor VFX mode
  vim.g.neovide_cursor_vfx_mode = "ripple"
end

-- Map Ctrl+i to move the cursor right
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true })

-- Map Ctrl+j to move the cursor down
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true })

-- Map Ctrl+k to move the cursor up
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true })

-- Map Ctrl+l to move the cursor left
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true })


vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>:nohlsearch<CR>', { noremap = true })
