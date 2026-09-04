return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { timeout = 5000 },
      zen = { toggles = { dim = false }, win = { wo = { number = false } } },
      styles = {
        zen = { width = 120, backdrop = { transparent = false } },
        notification = { wo = { wrap = true } },
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "LazyFile",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features
        css_fn = true, -- Enable all CSS *functions*
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
}
