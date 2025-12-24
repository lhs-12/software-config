return {
  {
    "vv9k/bogster",
    opts = {},
    config = function()
      vim.cmd.colorscheme("bogster")
      vim.api.nvim_set_hl(0, "Visual", { bg = "#4f5258" })
      vim.api.nvim_set_hl(0, "@variable", { fg = "#d0cbc4" })
      vim.api.nvim_set_hl(0, "Normal", { fg = "#d0cbc4", bg = "#161c23" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#007373", fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#06382E", fg = "#14ba99" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#452E1A", fg = "#dcb659" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#45232A", fg = "#dc597f" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#4D2314", fg = "#ff7043" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#1C2046", fg = "#5c6bc0" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1c212a" })
    end,
  },
}
