-- Bufferline Configuration
function _G.get_bufferline()
  local s = ""
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local name = vim.api.nvim_buf_get_name(bufnr)
      name = (name == "") and "[No Name]" or vim.fn.fnamemodify(name, ":t")
      
      local is_current = (bufnr == current_buf)
      
      if is_current then
        s = s .. "%#TabLineSel# " .. name .. " %*"
      else
        s = s .. "%#TabLine# " .. name .. " %*"
      end
    end
  end
  return s
end

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.get_bufferline()"

-- Keymaps
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })
