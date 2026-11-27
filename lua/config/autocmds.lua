-- Automatically hide terminal buffers from the bufferline
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.bo.buflisted = false
	end,
})

-- Update the tabline visibility whenever the buffer list changes
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufEnter" }, {
	callback = function()
		vim.opt.showtabline = Bufferline.get_bufferline_visibility()
	end,
})
