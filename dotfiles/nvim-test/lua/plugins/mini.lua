return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai") -- :h MiniAi-builtin-textobjects
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
  },
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
    "nvim-mini/mini.diff",
    event = "VeryLazy",
    keys = { { "<leader>go", function() require("mini.diff").toggle_overlay(0) end, desc = "mini.diff overlay" } },
    opts = { view = { style = "sign" } },
  },
  -- {
  --   "nvim-mini/mini.operators",
  --   event = "VeryLazy",
  --   -- stylua: ignore
  --   opts = {
  --     evaluate = { prefix = "g=", func = nil               },
  --     exchange = { prefix = "gx", reindent_linewise = true },
  --     multiply = { prefix = "gm", func = nil               },
  --     replace  = { prefix = "gr", reindent_linewise = true },
  --     sort     = { prefix = "gs", func = nil               },
  --   },
  -- },
}
