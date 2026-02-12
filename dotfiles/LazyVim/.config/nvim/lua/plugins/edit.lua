return {
  { "windwp/nvim-autopairs", event = "LazyFile", opts = {} }, -- optimize mini.pairs indent
  { "kylechui/nvim-surround", event = "LazyFile", opts = {} },
  {
    "nvim-mini/mini.align",
    event = "VeryLazy",
    opts = { mappings = { start = "ga", start_with_preview = "gA" } },
  },
  {
    "nvim-mini/mini.splitjoin",
    event = "VeryLazy",
    opts = { mappings = { toggle = "gS" } },
  },
  {
    "nvim-mini/mini.operators",
    event = "VeryLazy",
    -- stylua: ignore
    opts = {
      replace  = { prefix = "gp", reindent_linewise = true },
      exchange = { prefix = "gP", reindent_linewise = true },
      evaluate = { prefix = nil, func = nil },
      multiply = { prefix = nil, func = nil },
      sort     = { prefix = nil, func = nil },
    },
  },
  {
    "tigion/swap.nvim",
    keys = { { "`", mode = { "n" }, function() require("swap").switch() end, desc = "Swap word" } },
    opts = {
      all = { modules = { "opposites", "chains" } },
      chains = {
        words_by_ft = {
          -- stylua: ignore
          markdown = {
            { "- [ ]", "- [x]", "- [~]", "- [-]" }, -- render-markdown checkboxes
            { -- render-markdown callouts
              "> [!NOTE]", "> [!TIP]", "> [!IMPORTANT]", "> [!WARNING]", "> [!CAUTION]", "> [!ABSTRACT]",
              "> [!SUMMARY]", "> [!TLDR]", "> [!INFO]", "> [!TODO]", "> [!HINT]", "> [!SUCCESS]", "> [!CHECK]",
              "> [!DONE]", "> [!QUESTION]", "> [!HELP]", "> [!FAQ]", "> [!ATTENTION]", "> [!FAILURE]", "> [!FAIL]",
              "> [!MISSING]", "> [!DANGER]", "> [!ERROR]", "> [!BUG]", "> [!EXAMPLE]", "> [!QUOTE]", "> [!CITE]",
            },
          },
        },
      },
    },
  },
}
