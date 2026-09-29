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
          local bufnr = ev.buf
          local started = pcall(vim.treesitter.start, bufnr)
          if not started then return end

          local noIndent = {}
          if not vim.list_contains(noIndent, ev.match) then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
