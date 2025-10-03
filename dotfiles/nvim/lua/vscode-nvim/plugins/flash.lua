return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
    },
    config = function()
      require("flash").setup({
        labels = "asdfghjkl;qwertyuiopzxcvbnm,.",
        jump = { autojump = true },
      })
    end,
  },
}
