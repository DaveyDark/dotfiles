-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

-- Buffer
lvim.builtin.which_key.mappings['b'] = {
  c = { "<cmd>BufferKill<CR>", "Close Buffer" },
}
lvim.builtin.which_key.mappings['x'] = { "<cmd>BufferKill<CR>", "Close Buffer" }

-- Session
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

-- Symbols Outline
lvim.builtin.which_key.mappings["w"] = {
  "<cmd>:SymbolsOutline<CR>", "Outline"
}

-- CodeSnap
lvim.builtin.which_key.vmappings["c"] = {
  name = "+CodeSnap",
  c = { ":'<,'>CodeSnap<cr>", "Save selected code snapshot into clipboard" },
  C = { ":'<,'>CodeSnapSave<cr>", "Save selected code snapshot into Pictures" },
  h = { ":'<,'>CodeSnapHighlight<cr>", "Highlight selected code snapshot" },
  H = { ":'<,'>CodeSnapHighlightSave<cr>", "Highlight selected code snapshot and save into Pictures" },
}
