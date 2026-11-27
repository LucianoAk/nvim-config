local buffer_order = {}

local function update_buffer_order()
	local loaded_buffers = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
			loaded_buffers[bufnr] = true
		end
	end

	local new_order = {}
	for _, bufnr in ipairs(buffer_order) do
		if loaded_buffers[bufnr] then
			table.insert(new_order, bufnr)
			loaded_buffers[bufnr] = nil
		end
	end

	for bufnr, _ in pairs(loaded_buffers) do
		table.insert(new_order, bufnr)
	end

	buffer_order = new_order
end

local function move_buffer_in_order(direction)
	update_buffer_order()
	local current_buf = vim.api.nvim_get_current_buf()
	local idx = nil

	for i, bufnr in ipairs(buffer_order) do
		if bufnr == current_buf then
			idx = i
			break
		end
	end

	if not idx then
		return
	end

	local target_idx = direction == "left" and idx - 1 or idx + 1
	if target_idx >= 1 and target_idx <= #buffer_order then
		buffer_order[idx], buffer_order[target_idx] = buffer_order[target_idx], buffer_order[idx]
	end
end

local function enter_buffer_mode(config)
	config = vim.tbl_deep_extend("force", {
		start_on_move = true,
		move_left = "h",
		move_right = "l",
		move_on = "k",
		move_off = "j",
		delete = "d",
		exit = "q",
	}, config or {})

	local move = config.start_on_move
	print(
		string.format(
			"Buffer Mode [MOVE: %s] — [%s/%s] move | [%s] move ON | [%s] move OFF | [%s] delete | [%s] exit",
			move and "ON" or "OFF",
			config.move_left,
			config.move_right,
			config.move_on,
			config.move_off,
			config.delete,
			config.exit
		)
	)

	while true do
		vim.cmd("redraw")
		local char = vim.fn.getcharstr()

		if char == config.move_left then
			if move then
				move_buffer_in_order("left")
			else
				vim.cmd("bprev")
			end
		elseif char == config.move_right then
			if move then
				move_buffer_in_order("right")
			else
				vim.cmd("bnext")
			end
		elseif char == config.move_off then
			move = false
			print("Buffer Mode [MOVE: OFF (Cycling)]")
		elseif char == config.move_on then
			move = true
			print("Buffer Mode [MOVE: ON (Shifting)]")
		elseif char == config.delete then
			vim.cmd("bdelete")
			print("Buffer deleted.")
		elseif char == config.exit then
			print("Exited buffer mode.")
			break
		else
			print(string.format("Unknown key: %s", char))
		end
	end
end

local function get_bufferline()
	update_buffer_order()
	local s = ""
	local current_buf = vim.api.nvim_get_current_buf()

	for _, bufnr in ipairs(buffer_order) do
		local name = vim.api.nvim_buf_get_name(bufnr)
		name = (name == "") and "[No Name]" or vim.fn.fnamemodify(name, ":t")

		local is_current = (bufnr == current_buf)
		local highlight = is_current and "%#TabLineSel# " or "%#TabLine# "

		s = s .. highlight .. name .. " %*"
	end

	return s
end

_G.enter_buffer_mode = enter_buffer_mode
_G.get_bufferline = get_bufferline

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.get_bufferline()"
