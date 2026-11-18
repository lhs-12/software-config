return {
  {
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
      checkbox = {
        unchecked = { icon = "◯ " },
        checked = { icon = "✔ ", scope_highlight = '@markup.strikethrough' },
        custom = {
          todo = { raw = "[~]", rendered = "󰦖 ", highlight = "RenderMarkdownInfo" },
          canceled = { raw = "[-]", rendered = "✘ ", highlight = "RenderMarkdownError" },
        },
      },
      anti_conceal = { disabled_modes = { "n" } },
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
      win_options = { concealcursor = { rendered = "nvc" } },

      -- TODO: https://github.com/patricorgi/dotfiles/blob/main/.config/nvim
      -- 添加图片: img-clip.nvim
      -- 格式化: pretierd + cbfmt
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  },
}
