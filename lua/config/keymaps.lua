-- ###################
-- # Toggle Terminal #
-- ###################
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  vim.cmd("botright 20split")
  term_win = vim.api.nvim_get_current_win()

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end

for _, key in ipairs({ "<C-\\>", "<C-/>" }) do
    vim.keymap.set({ "n", "t" }, key, toggle_terminal, { desc = "Toggle Main Terminal" })
end

-- ###################
-- # Toggle Explorer #
-- ###################
local explorer_buf = nil
local explorer_win = nil

local function toggle_explorer()
  if explorer_win and vim.api.nvim_win_is_valid(explorer_win) then
    if vim.api.nvim_get_current_win() == explorer_win then
      vim.api.nvim_win_hide(explorer_win)
      explorer_win = nil
    else
      vim.api.nvim_set_current_win(explorer_win)
    end
    return
  end

  vim.cmd("topleft 30vsplit")
  explorer_win = vim.api.nvim_get_current_win()

  if explorer_buf and vim.api.nvim_buf_is_valid(explorer_buf) then
    vim.api.nvim_win_set_buf(explorer_win, explorer_buf)
  else
    vim.cmd("edit .")
    explorer_buf = vim.api.nvim_get_current_buf()
  end
end

vim.keymap.set("n", "<leader>e", toggle_explorer, { silent = true, desc = "Toggle or Focus File Explorer Sidebar" })

-- #########################################
-- # Turn off Search Highlight using <Esc> #
-- #########################################
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- ################################################
-- # Change focus of split using <Ctrl + h/j/k/l> #
-- ################################################
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- ###################################
-- # Replace in the selection keymap #
-- ###################################
local function replace_selection()
  local start_line = math.min(vim.fn.line("v"), vim.fn.line("."))
  local end_line = math.max(vim.fn.line("v"), vim.fn.line("."))

  local target = vim.fn.input("Replace: ")
  local replacement = vim.fn.input("With: ")

  if target == "" then
    return
  end

  target = vim.fn.escape(target, [[\/]])
  replacement = vim.fn.escape(replacement, [[\/&]])

  local ok = pcall(function()
    vim.cmd(string.format("%d,%ds/%s/%s/g", start_line, end_line, target, replacement))
  end)

  if not ok then
    vim.notify("Pattern not found: " .. target, vim.log.levels.ERROR)
  end
end

vim.keymap.set("v", "<leader>r", replace_selection, { desc = "Replace in the selection" })
