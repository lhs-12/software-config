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
      -- 用全局 mise java 运行 jdtls, 缺失则提前结束
      local ok_jdtls, jdtls_home = pcall(function()
        local r = vim.system({ "mise", "-C", "/", "where", "java" }, { text = true }):wait()
        local path = vim.trim(r.stdout)
        return r.code == 0 and path ~= "" and path or nil
      end)
      if not ok_jdtls or not jdtls_home then return opts end

      -- java.configuration.runtimes[].name 不是能随意定义的显示名, 而是 ExecutionEnvironment id,
      -- 该名称需要和 Eclipse 内置的 EE 列表项匹配, 否则无法正常绑定
      local function ee_id(path)
        local ok, lines = pcall(vim.fn.readfile, path .. "/release")
        for _, line in ipairs(ok and lines or {}) do
          local version = line:match('^JAVA_VERSION="([^"]+)"')
          -- 1.8.0_504 -> JavaSE-1.8 ; 25.0.2 -> JavaSE-25
          local prefix = version and (version:match("^1%.%d+") or version:match("^%d+"))
          if prefix then return "JavaSE-" .. prefix end
        end
      end

      -- runtimes: 只注册 mise 状态为 active 的 java
      local jdk_runtimes = {}
      local ok_ls, installs = pcall(function()
        local out = vim.system({ "mise", "ls", "java", "--json" }, { text = true }):wait().stdout or ""
        return vim.json.decode(out)
      end)
      for _, install in ipairs(ok_ls and installs or {}) do
        local ee = install.active and ee_id(install.install_path)
        if ee then table.insert(jdk_runtimes, { name = ee, path = install.install_path }) end
      end
      opts.cmd = vim.list_extend(opts.cmd, {
        "--java-executable=" .. jdtls_home .. "/bin/java",
        "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
        "--jvm-arg=-Xms512m",
        "--jvm-arg=-Xmx2G",
      })
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = { configuration = { runtimes = jdk_runtimes } },
      })
      return opts
    end,
  },
}
