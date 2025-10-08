return {
  "vv9k/bogster",
  opts = {},
  config = function(_, opts)
    vim.cmd.colorscheme("bogster")
    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#232d38" })
  end,
}