-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--  name = "+Trouble",
--  r = { "<cmd>Trouble lsp_references<cr>", "References" },
--  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

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

-- Neorg
lvim.builtin.which_key.mappings["n"] = {
  name = "Neorg",
  h = { "<cmd>:Neorg index<cr>", "Home" },
  w = { "<cmd>:Neorg workspace<cr>", "Workspaces" },
  e = { "<cmd>:Neorg toc<cr>", "Table Of Contents" },
  s = { "<cmd>:Neorg generate-workspace-summary<cr>", "Summary Generation" },
  m = { "<cmd>:Neorg inject-metadata<cr>", "Add Metadata" },
  M = { "<cmd>:Neorg inject-metadata<cr>", "Update Metadata" },
  T = { "<cmd>:Neorg toggle-concealer<cr>", "Toggle Concealer" },
  n = { "<cmd>:Neorg keybind norg core.dirman.new.note <cr>", "New Note" },
  t = {
    name = "Tasks",
    d = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_done <cr>", "Task Done" },
    u = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_undone <cr>", "Task Undone" },
    p = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_pending <cr>", "Task Pending" },
    h = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_on_hold <cr>", "Task On Hold" },
    c = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_cancelled <cr>", "Task Cancelled" },
    r = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_recurring <cr>", "Task Recurring" },
    i = { "<cmd>:Neorg keybind norg core.qol.todo_items.todo.task_important <cr>", "Task Important" },
  },
  j = {
    name = "Journal",
    n = { "<cmd>:Neorg journal today<cr>", "New Journal Entry(Today)" },
    N = { "<cmd>:Neorg journal yesterday<cr>", "New Journal Entry(Yesterday)" },
    T = { "<cmd>:Neorg journal template<cr>", "Edit Template" },
    t = { "<cmd>:Neorg journal toc update<cr>", "Table Of Contents" },
  }
}
