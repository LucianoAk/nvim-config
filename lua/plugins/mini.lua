-- My set of plugins from the mini.nvim library: https://nvim-mini.org/mini.nvim/
return {
	"nvim-mini/mini.nvim",
	event = "VeryLazy",
	version = false,
	config = function()
		-- ### mini.pick ###
		require("mini.pick").setup({
			mappings = {
				caret_left = "<Left>",
				caret_right = "<Right>",
				choose = "<CR>",
				choose_in_split = "<C-s>",
				choose_in_tabpage = "<C-t>",
				choose_in_vsplit = "<C-v>",
				choose_marked = "<M-CR>",
				delete_char = "<BS>",
				delete_char_right = "<Del>",
				delete_left = "<C-u>",
				delete_word = "<C-w>",
				mark = "<C-x>",
				mark_all = "<C-a>",
				move_down = "<C-n>",
				move_start = "<C-g>",
				move_up = "<C-p>",
				paste = "<C-r>",
				refine = "<C-Space>",
				refine_marked = "<M-Space>",
				scroll_down = "<C-f>",
				scroll_left = "<C-h>",
				scroll_right = "<C-l>",
				scroll_up = "<C-b>",
				stop = "<Esc>",
				toggle_info = "<S-Tab>",
				toggle_preview = "<Tab>",
			},
		})

		vim.keymap.set("n", "<leader><space>", function()
			MiniPick.builtin.files()
		end, { desc = "Find Project Files" })

		vim.keymap.set("n", "<leader>bb", function()
			MiniPick.builtin.buffers()
		end, { desc = "Find Project Files" })

		-- ### mini.pairs ###
		require("mini.pairs").setup({
			mappings = {
				["("] = { action = "open", pair = "()", neigh_pattern = "^[^\\]" },
				["["] = { action = "open", pair = "[]", neigh_pattern = "^[^\\]" },
				["{"] = { action = "open", pair = "{}", neigh_pattern = "^[^\\]" },
				[")"] = { action = "close", pair = "()", neigh_pattern = "^[^\\]" },
				["]"] = { action = "close", pair = "[]", neigh_pattern = "^[^\\]" },
				["}"] = { action = "close", pair = "{}", neigh_pattern = "^[^\\]" },
				['"'] = { action = "closeopen", pair = '""', neigh_pattern = "^[^\\]", register = { cr = false } },
				["'"] = { action = "closeopen", pair = "''", neigh_pattern = "^[^%a\\]", register = { cr = false } },
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "^[^\\]", register = { cr = false } },
			},
		})

		-- ### mini.move ###
		require("mini.move").setup({
			mappings = {
				left = "<M-h>",
				right = "<M-l>",
				down = "<M-j>",
				up = "<M-k>",
				line_left = "<M-h>",
				line_right = "<M-l>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},
		})

		-- ### mini.snippets ###
		local gen_loader = require("mini.snippets").gen_loader
		local config_path = vim.fn.stdpath("config")
		require("mini.snippets").setup({
			snippets = {
				gen_loader.from_file(config_path .. "/snippets/global.lua"),
				gen_loader.from_lang(),
			},
			mappings = {
				expand = "<C-j>",
				jump_next = "<C-l>",
				jump_prev = "<C-h>",
				stop = "<C-c>",
			},
		})

		-- ### mini.surround ###
		require("mini.surround").setup({
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				suffix_last = "l",
				suffix_next = "n",
			},
		})
	end,
}
