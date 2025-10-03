return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  spec = { vscode = true },
  config = function()
    require("nvim-surround").setup({
      -- stylua: ignore
      keymaps = {
        normal = "ys", normal_cur = "yss", normal_line = "yS",
        visual = "S", visual_line = "gS",
        delete = "ds", change = "cs",
      },
      aliases = {
        ["b"] = "**", ["i"] = "_", -- for markdown
      },
    })
  end,
}
