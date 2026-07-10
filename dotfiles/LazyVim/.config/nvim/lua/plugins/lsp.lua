return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        -- exclude = { "python", "java" },
        enabled = false,
      },
      servers = {
        -- Python
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- use Ruff
              analysis = {
                diagnosticMode = "workspace",
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
    },
  },
  -- Java
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- 通过 mise 获取已装 java 清单与全局激活版本.
      -- 在 mise 全局配置目录 (~/.config/mise) 执行, 使 active 反映全局 config.toml 的 java,
      -- 不受当前项目目录影响 (mise 会按目录切换环境).
      local out = vim.system(
        { "mise", "ls", "java", "--json" },
        { cwd = vim.fn.expand("~/.config/mise"), text = true }
      ):wait()
      local entries = vim.json.decode(out.stdout or "[]")
      -- runtimes: 已安装的 java 全部列出, name 用 mise 显示的版本号, 由 jdtls 匹配项目 java 版本
      local jdk_runtimes = {}
      local jdtls_home
      for _, t in ipairs(entries) do
        if t.installed then
          jdk_runtimes[#jdk_runtimes + 1] = { name = t.version, path = t.install_path }
          if t.active then jdtls_home = t.install_path end
        end
      end
      -- jdtls 启动 JVM = 全局激活的 java; 全局未配置则取首个已安装; 都没有则用 PATH 的 java
      jdtls_home = jdtls_home or (jdk_runtimes[1] and jdk_runtimes[1].path)
      local jdtls_execute = jdtls_home and (jdtls_home .. "/bin/java") or "java"
      table.insert(opts.cmd, "--java-executable=" .. jdtls_execute)
      table.insert(opts.cmd, "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false")
      table.insert(opts.cmd, "-Dlog.perf.level=OFF")
      table.insert(opts.cmd, "--jvm-arg=-Xms256m")
      table.insert(opts.cmd, "--jvm-arg=-Xmx2G")
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = { configuration = { runtimes = jdk_runtimes } },
      })
      return opts
    end,
  },
}
