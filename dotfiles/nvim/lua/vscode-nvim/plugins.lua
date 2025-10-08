return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = { { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end } },
    opts = {
      labels = "asdfghjkl;qwertyuiopzxcvbnm,.",
      jump = { autojump = true },
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
