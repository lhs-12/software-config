return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = { -- 去掉markdownlint-cli2
        ["markdown"] = { "prettier", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdown-toc" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = { linters_by_ft = { markdown = {} } }, -- 去掉markdownlint-cli2
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "LazyFile",
    opts = {
      -- stylua: ignore
      code = {
        sign = true,
        width = "block", min_width = 80,
        border = "thin", left_pad = 1, right_pad = 1,
        position = "right", language_icon = true, language_name = true,
        highlight_inline = "RenderMarkdownCodeInfo",
      },
      heading = { sign = true },
      checkbox = {
        enabled = true,
        unchecked = { icon = "◯ " },
        checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
        custom = {
          todo = { raw = "[~]", rendered = "󰦖 ", highlight = "RenderMarkdownInfo" },
          canceled = { raw = "[-]", rendered = "✘ ", highlight = "RenderMarkdownError" },
        },
      },
      anti_conceal = { disabled_modes = { "n" } },
      -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
      win_options = { concealcursor = { rendered = "nvc" } },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  },
}
