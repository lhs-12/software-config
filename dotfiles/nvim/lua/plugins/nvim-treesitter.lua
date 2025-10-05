return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- master已被封存版本转main, 但main暂时无法正常启动, 等待main稳定迁移(configs需要改成config)
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
          -- 对于依赖旧 syntax 的语言, 可启用额外正则高亮, 可能慢
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
        -- 增量选择
        incremental_selection = {
          enable = false,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },
}
