return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "LazyFile",
  opts = {
    -- stylua: ignore
    code = {
      width = "block", min_width = 80,
      border = "thin", left_pad = 1, right_pad = 1,
      position = "right", language_icon = true, language_name = true,
      highlight_inline = "RenderMarkdownCodeInfo",
    },
    anti_conceal = { disabled_modes = { "n" } },
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
    win_options = { concealcursor = { rendered = "nvc" } },

    -- TODO:
    -- 代码补全: blink.cmp, markdown lsp
    -- completions = {
    --   blink = { enabled = true },
    --   lsp = { enabled = true },
    -- },
    -- 图标状态切换: switch.nvim,
    -- 图片预览: snacks.nvim
    -- 添加图片: img-clip.nvim
    -- 自动添加列表前缀: bullets.nvim
    -- 双向链接: marksman lsp
    -- 格式化: pretierd + cbfmt
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
}
