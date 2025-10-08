return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- 等待main稳定迁移
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- stylua: ignore
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "bash", "query", "markdown", "markdown_inline",
          "java", "python", "json", "xml", "yaml", "toml", "sql", "dockerfile",
          "html", "javascript", "typescript", "css", "vue", "tsx"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          -- 禁用某些语言或大文件的高亮（示例函数）
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then return true end
          end,
        },
        -- 缩进模块（实验性）
        indent = { enable = true },
      })
    end,
  },
}
