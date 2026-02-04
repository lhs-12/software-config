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
        -- Windows
        local jdk_8 = "$USERPROFILE/.jdks/adopt-openjdk-1.8.0_302"
        local jdk_25 = "$USERPROFILE/.jdks/openjdk-25"
        jdtls_execute = vim.fn.expand(jdk_25 .. "/bin/java")
        jdk_runtimes = {
          { name = "JDK-8", path = vim.fn.expand(jdk_8) },
          { name = "JDK-25", path = vim.fn.expand(jdk_25) },
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
