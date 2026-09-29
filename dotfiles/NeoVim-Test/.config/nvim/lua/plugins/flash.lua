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
line_opts = { search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "s"    , mode = { "n", "x", "o" }, function() require("flash").jump()              end, desc = "Flash"               },
      { "S"    , mode = { "n", "x", "o" }, function() require("flash").treesitter()        end, desc = "Flash Treesitter"    },
      { "s;"   , mode = { "n", "x", "o" }, function() flash_chars()                        end, desc = "Flash Chars"         },
      { "s'"   , mode = { "n", "x", "o" }, function() require("flash").jump(line_opts)     end, desc = "Flash Line"          },
      { "r"    , mode = { "o" }          , function() require("flash").remote()            end, desc = "Remote Flash"        },
      { "R"    , mode = { "o", "x" }     , function() require("flash").treesitter_search() end, desc = "Treesitter Search"   },
      { "<c-s>", mode = { "c" }          , function() require("flash").toggle()            end, desc = "Toggle Flash Search" },
    },
    opts = {
      labels = "asdfghjkl;qwertyuiopzxcvbnm,.",
      jump = { autojump = true },
    },
    specs = {
      -- 支持snacks.picker
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
}
