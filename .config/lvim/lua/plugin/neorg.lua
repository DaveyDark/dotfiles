require("neorg").setup {
  load = {
    ["core.defaults"] = {},  -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.keybinds"] = {
      config = {
        -- not remapping existing keybinds, only adding opts desc for which-key
        hook = function(keybinds)
          keybinds.unmap("norg", "n", "gtd")
          keybinds.unmap("norg", "n", "gtu")
          keybinds.unmap("norg", "n", "gtx")
          keybinds.unmap("norg", "n", "gth")
          keybinds.unmap("norg", "n", "gtc")
          keybinds.unmap("norg", "n", "gtr")
          keybinds.unmap("norg", "n", "gti")
          keybinds.unmap("norg", "n", "<leader>nn")
        end
      },
    },
    ["core.summary"] = {},
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      }
    },
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          main = "~/Documents/neorg/",
        },
        default_workspace = "main",
      },
    },
    ["core.journal"] = {
      config = {
        strategy = "flat",
        workspace = "default",
      }
    }
  },
}
