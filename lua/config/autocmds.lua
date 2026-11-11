-- Automatically hide terminal buffers from the bufferline
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.bo.buflisted = false
	end,
})
