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
      local jdk_runtimes
      local jdtls_execute
      local sys = vim.uv.os_uname().sysname:lower()
      if sys:find("windows") or sys:find("mingw") or sys:find("msys") then
        -- Windows (mise)
        -- mise 版本别名 (如 "25"/"temurin-8") 在 Windows 上是纯文本文件而非真符号链接,
        -- 内容为相对路径 (如 ".\25.0.2"), 需读取并解析为真实安装目录.
        local function resolve_mise_alias(path)
          path = vim.fn.expand(path)
          local st = vim.uv.fs_stat(path)
          if not st or st.type == "directory" then return path end
          local target = vim.fn.readfile(path)[1]
          if target then
            target = (vim.trim(target):gsub("^%.[/\\]", ""))
            if target ~= "" then return vim.fn.fnamemodify(path, ":h") .. "/" .. target end
          end
          return path
        end
        local mise_java = "$USERPROFILE/AppData/Local/mise/installs/java"
        local jdk_8 = resolve_mise_alias(mise_java .. "/temurin-8")
        local jdk_25 = resolve_mise_alias(mise_java .. "/25")
        jdtls_execute = jdk_25 .. "/bin/java"
        jdk_runtimes = {
          { name = "JDK-8", path = jdk_8 },
          { name = "JDK-25", path = jdk_25 },
        }
      else
        -- Unix
        local jdk_8 = "$HOME/.local/share/mise/installs/java/temurin-8"
        local jdk_25 = "$HOME/.local/share/mise/installs/java/25"        
        jdtls_execute = vim.fn.expand(jdk_25 .. "/bin/java")
        jdk_runtimes = {
          { name = "JDK-8", path = vim.fn.expand(jdk_8) },
          { name = "JDK-25", path = vim.fn.expand(jdk_25) },
        }
      end
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
