local plugins = {
  {
    "mfussenegger/nvim-dap",
    config = function ()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialezed["dapui_config"] = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function ()
        dapui.close()
      end
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function ()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function (_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function (_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function ()
      vim.cmd [[silent! GoInstallDeps]]
    end
  },
  {
    "nvimtools/none-ls.nvim",
    ft = {"python", "go", "terraform", "hcl"},
    opts = function ()
      return require("custom.configs.none-ls")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "black",
        "debugpy",
        "mypy",
        "ruff",
        "pyright",
        -- Go
        "gopls",
        "gofumpt",
        "goimports-reviser",
        "golines",
        "gomodifytags",
        "delve",
        -- Terraform
        "terraform-ls",
        "tflint",
        -- Others
        "docker-compose-language-service",
        "dockerfile-language-server",
        "bash-language-server",
        "json-lsp",
        "yaml-language-server",
      },
    },
  },
  -- If any day this PR is merged delete this custom
  -- https://github.com/numToStr/Comment.nvim/pull/398
  {
    "numToStr/Comment.nvim",
    config = function ()
      local ft = require('Comment.ft')
      ft.hcl = { '#%s', '/*%s*/' }

      require('Comment').setup()
    end
  }
}
return plugins
