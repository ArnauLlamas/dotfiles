local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "json-lsp",
        "yaml-language-server",
        "terraform-ls",
        "tflint",
      },
    },
  }
}
return plugins
