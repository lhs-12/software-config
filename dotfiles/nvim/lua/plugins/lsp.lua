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
      local jdk_8 = "$USERPROFILE/.jdks/adopt-openjdk-1.8.0_302"
      local jdk_25 = "$USERPROFILE/.jdks/openjdk-25"
      local jdtls_execute = vim.fn.expand(jdk_25 .. "/bin/java")

      table.insert(opts.cmd, "--java-executable=" .. jdtls_execute)
      table.insert(opts.cmd, "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false")
      table.insert(opts.cmd, "-Dlog.perf.level=OFF")
      table.insert(opts.cmd, "--jvm-arg=-Xms256m")
      table.insert(opts.cmd, "--jvm-arg=-Xmx2G")

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = {
              { name = "JDK-8", path = vim.fn.expand(jdk_8) },
              { name = "JDK-25", path = vim.fn.expand(jdk_25) },
            },
          },
        },
      })
      return opts
    end,
  },
}
