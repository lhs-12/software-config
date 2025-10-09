return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      vim.g._ts_force_sync_parsing = false
      -- stylua: ignore
      local ensure_installed = {
        "c", "lua", "vim", "vimdoc", "bash", "query", "diff", "markdown", "markdown_inline", 
        "java", "python", "json", "regex", "xml", "yaml", "toml", "sql", "dockerfile",
        "html", "javascript", "typescript", "css", "vue", "tsx",
      }
      local alreadyInstalled = treesitter.get_installed()
      local parsersToInstall = vim
        .iter(ensure_installed)
        :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
        :totable()
      treesitter.install(parsersToInstall)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(ev)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
          if ok and stats and stats.size > max_filesize then return end

          local bufnr = ev.buf
          local started = pcall(vim.treesitter.start, bufnr)
          if not started then return end

          local noIndent = {}
          if not vim.list_contains(noIndent, ev.match) then
            vim.wo.foldmethod = "expr"
            vim.wo.foldlevel = 99
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("nvim-treesitter.config").setup({})
      local to_s = require"nvim-treesitter-textobjects.select"
      local to_m = require"nvim-treesitter-textobjects.move"
      vim.keymap.set({ "x", "o" }, "af", function() to_s.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() to_s.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ac", function() to_s.select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ic", function() to_s.select_textobject("@class.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]f", function() to_m.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() to_m.goto_previous_start("@function.outer", "textobjects") end)
    end,
  },
}
