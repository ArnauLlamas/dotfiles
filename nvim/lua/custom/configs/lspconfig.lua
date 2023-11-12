local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"terraform", "terraform-vars", "hcl"},
  root_dir = util.root_pattern(".terraform", "main.tf", ".git")
})

lspconfig.tflint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"terraform", "terraform-vars", "hcl"}
})

lspconfig.helm_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"helm","yaml"},
  root_dir = util.root_pattern("Chart.yaml", "templates", ".git")
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"shell", "sh", "bash"}
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"yaml"}
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true
      },
      gofumpt = true
    },
  },
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"}
})
