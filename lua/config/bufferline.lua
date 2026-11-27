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

local buffer_mode_active = false
local buffer_mode_keymaps = {}

local function exit_buffer_mode()
	if not buffer_mode_active then
		return
	end

	for key, _ in pairs(buffer_mode_keymaps) do
		pcall(vim.keymap.del, "n", key)
	end

	buffer_mode_active = false
end

local function enter_buffer_mode(config)
	if buffer_mode_active then
		return
	end
	buffer_mode_active = true

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

	local function print_buffer_mode_ui(active_key)
		if active_key == config.exit then
			print("Exited buffer mode")
			return
		end
		vim.api.nvim_echo({
			{ "Buffer Mode ", "Title" },
			{ "[MOVE: " },
			{ move and "ON" or "OFF", move and "DiagnosticOk" or "DiagnosticError" },
			{ "] — " },
			{ "[" .. config.move_left .. "]", active_key == config.move_left and "IncSearch" or "Special" },
			{ "/" },
			{ "[" .. config.move_right .. "]", active_key == config.move_right and "IncSearch" or "Special" },
			{ " move | " },
			{ "[" .. config.move_on .. "]", active_key == config.move_on and "IncSearch" or "Special" },
			{ " move ON | " },
			{ "[" .. config.move_off .. "]", active_key == config.move_off and "IncSearch" or "Special" },
			{ " move OFF | " },
			{ "[" .. config.delete .. "]", active_key == config.delete and "IncSearch" or "Special" },
			{ " delete | " },
			{ "[" .. config.exit .. "]", "Special" },
			{ " exit" },
		}, false, {})
	end

	print_buffer_mode_ui()

	buffer_mode_keymaps = {
		[config.move_left] = function()
			if move then
				move_buffer_in_order("left")
			else
				vim.cmd("bprev")
			end

			print_buffer_mode_ui(config.move_left)
		end,

		[config.move_right] = function()
			if move then
				move_buffer_in_order("right")
			else
				vim.cmd("bnext")
			end

			print_buffer_mode_ui(config.move_right)
		end,

		[config.move_off] = function()
			move = false
			print_buffer_mode_ui(config.move_off)
		end,

		[config.move_on] = function()
			move = true
			print_buffer_mode_ui(config.move_on)
		end,

		[config.delete] = function()
			vim.cmd("bdelete")
			print_buffer_mode_ui(config.delete)
		end,

		[config.exit] = function()
			exit_buffer_mode()
			print_buffer_mode_ui(config.exit)
		end,
	}

	for key, callback in pairs(buffer_mode_keymaps) do
		vim.keymap.set("n", key, callback, {
			noremap = true,
			silent = true,
		})
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
