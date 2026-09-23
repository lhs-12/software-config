return {
  { "windwp/nvim-autopairs", event = "LazyFile", opts = {} },
  { "windwp/nvim-ts-autotag", event = "LazyFile", opts = {} },

  --     Old text                    Command         New text
  -- ----------------------------------------------------------------------
  --     surr*ound_words             ysiw)           (surround_words)
  --     surr*ound_words             ysiw(           ( surround_words )
  --     *make strings               ys$"            "make strings"
  --     [delete ar*ound me!]        ds]             delete around me!
  --     remove <b>HTML t*ags</b>    dst             remove HTML tags
  --     'change quot*es'            cs'"            "change quotes"
  --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
  --     delete(functi*on calls)     dsf             function calls
  { "kylechui/nvim-surround", event = "LazyFile", opts = {} },
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
    "numToStr/Comment.nvim",
    event = "LazyFile",
    opts = {
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gc", block = "gb" },
      extra = { above = "gcO", below = "gco", eol = "gcA" },
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
