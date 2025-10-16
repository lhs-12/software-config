flash_chars = function()
  local Flash = require("flash")
  local function format(opts) return { { opts.match.label1, "FlashMatch" }, { opts.match.label2, "FlashLabel" } } end
  Flash.jump({
    search = { mode = "search" },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m) return m.label == match.label and m.win == win end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end
flash_line_opts = { search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "s;", mode = { "n", "x", "o" }, function() flash_chars() end },
      { "s'", mode = { "n", "x", "o" }, function() require("flash").jump(flash_line_opts) end },
    },
    opts = {
      labels = "asdfghjkl;qwertyuiopzxcvbnm,.",
      jump = { autojump = true },
    },
  },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.align", event = "VeryLazy", opts = { mappings = { start = "ga"} } },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai") -- :h MiniAi-builtin-textobjects
      return {
        n_lines = 100,
        custom_textobjects = {
          e = function() -- e for entire buffer
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
}
