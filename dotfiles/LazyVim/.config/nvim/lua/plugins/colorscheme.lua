return {
  {
    "vv9k/bogster",
    opts = {},
    config = function()
      vim.cmd.colorscheme("bogster")
      vim.api.nvim_set_hl(0, "@variable", { fg = "#c6bfba" })
      vim.api.nvim_set_hl(0, "Normal", { fg = "#c6bfba", bg = "#161c23" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#252f3b" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#1a2b27", fg = "#59dcb7" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#18262e", fg = "#4fbadb" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#1e2e1e", fg = "#6fcc4c" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#2b271a", fg = "#dfc26b" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#2c1c22", fg = "#db567c" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#2c1a27", fg = "#dc59c0" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1c242d" })
    end,
  },
}
