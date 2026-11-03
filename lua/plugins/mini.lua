-- My set of plugins from the mini.nvim library: https://nvim-mini.org/mini.nvim/
return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function ()
      -- ### mini.pick ###
      require("mini.pick").setup()

      vim.keymap.set("n", "<leader><space>", function()
          MiniPick.builtin.files()
      end, { desc = "Find Project Files" })

      -- ### mini.pairs ###
      require("mini.pairs").setup()

      -- ### mini.move ###
      require("mini.move").setup()

      -- ### mini.snippets ###
      local gen_loader = require('mini.snippets').gen_loader
      local config_path = vim.fn.stdpath("config")
      require('mini.snippets').setup({
        snippets = {
          gen_loader.from_file(config_path .. "/snippets/global.json"),
          gen_loader.from_lang(),
        }
      })
    end
  },
}
