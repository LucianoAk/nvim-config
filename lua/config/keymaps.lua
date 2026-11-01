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

vim.keymap.set({ "n", "t" }, "<C-\\>", toggle_terminal, { desc = "Toggle Main Terminal" })

-- ###################
-- # Toggle Explorer #
-- ###################
vim.keymap.set("n", "<leader>e", function()
  local netrw_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "netrw" then
      netrw_win = win
      break
    end
  end

  if netrw_win then
    if vim.api.nvim_get_current_win() == netrw_win then
      vim.cmd("Lexplore!")
    else
      vim.api.nvim_set_current_win(netrw_win)
    end
  else
    vim.cmd("Lexplore!")
  end
end, { silent = true, desc = "Toggle or Focus File Explorer Sidebar" })

-- #########################################
-- # Turn off Search Highlight using <Esc> #
-- #########################################
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })
