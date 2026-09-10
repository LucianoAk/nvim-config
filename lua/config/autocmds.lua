-- Prevent empty ghost buffers when closing netrw, caused by the explorer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.bufhidden = "wipe"
  end,
})

-- Automatically hide terminal buffers from the bufferline
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.bo.buflisted = false
  end,
})
