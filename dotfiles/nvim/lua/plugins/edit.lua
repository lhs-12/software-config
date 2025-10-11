return {
  { "windwp/nvim-autopairs", event = "LazyFile", opts = {} },
  { "windwp/nvim-ts-autotag", event = "LazyFile", opts = {} },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 100, -- context lines
        custom_textobjects = {
          -- treesitter-textobjects.select
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          -- e for entire buffer
          e = function()
            local from = { line = 1, col = 1 }
            local to = { line = vim.fn.line("$"), col = vim.fn.col({ vim.fn.line("$"), "$" }) }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts) require("mini.ai").setup(opts) end, -- :h MiniAi-builtin-textobjects
  },

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
}
