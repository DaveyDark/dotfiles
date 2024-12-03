-- Additional Plugins
lvim.plugins = {
  {
    -- Utility
    "andweeb/presence.nvim",
    {
      "folke/todo-comments.nvim",
      event = "BufRead",
      config = function()
        require("todo-comments").setup()
      end,
    },
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },

    -- LSP features
    {
      "ray-x/lsp_signature.nvim",
      event = "BufRead",
      config = function() require "lsp_signature".on_attach() end,
    },
    {
      "simrat39/symbols-outline.nvim",
      config = function()
        require('symbols-outline').setup()
      end
    },
    "neovim/nvim-lspconfig",
    "simrat39/rust-tools.nvim",
    "HiPhish/nvim-ts-rainbow2",
    -- {
    --   "ahmedkhalf/lsp-rooter.nvim",
    --   event = "BufRead",
    --   config = function()
    --     require("lsp-rooter").setup()
    --   end,
    -- },


    -- Completion sources
    -- {
    --   "tzachar/cmp-tabnine",
    --   event = "InsertEnter",
    --   build = "./install.sh"
    -- },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({})
      end,
    },
    {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup()
      end
    },
    "normen/vim-pio",



    -- Themes
    "morhetz/gruvbox",
    "lunarvim/horizon.nvim",
    "tomasr/molokai",
    "ayu-theme/ayu-vim",
    "yonlu/omni.vim",
    "ray-x/aurora",
    "tiagovla/tokyodark.nvim",
    "rmehri01/onenord.nvim",
    -- "olimorris/onedarkpro.nvim",
    "ofirgall/ofirkai.nvim",
    "catppuccin/nvim",
    "Mofiqul/dracula.nvim",


    -- Feature plugins
    "iamcco/markdown-preview.nvim",
    {
      "folke/trouble.nvim",
    },
    {
      "ethanholz/nvim-lastplace",
      event = "BufRead",
      config = function()
        require("nvim-lastplace").setup({
          lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
          lastplace_ignore_filetype = {
            "gitcommit", "gitrebase", "svn", "hgcommit",
          },
          lastplace_open_folds = true,
        })
      end,
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      config = function()
        require("persistence").setup {
          dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
          options = { "buffers", "curdir", "tabpages", "winsize" },
        }
      end,
    },
    {
      "turbio/bracey.vim",
      cmd = { "Bracey", "BracyStop", "BraceyReload", "BraceyEval" },
      build = "npm install --prefix server",
    },
    {
      'akinsho/flutter-tools.nvim',
      lazy = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
      },
      config = true,
    },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
          RGB = true,      -- #RGB hex codes
          RRGGBB = true,   -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true,   -- CSS rgb() and rgba() functions
          hsl_fn = true,   -- CSS hsl() and hsla() functions
          css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
        })
      end,
    },
    {
      "tpope/vim-surround",
    },
    {
      "mistricky/codesnap.nvim",
      build = "make build_generator",
      opts = {
        save_path = "~/Pictures/codesnap",
        has_breadcrumbs = true,
        bg_theme = "grape",
        watermark = "",
        bg_x_padding = 61,
        bg_y_padding = 41,
        bg_padding = nil
      },
    },
    {
      "YannickFricke/codestats.nvim",
    }
  },
}
