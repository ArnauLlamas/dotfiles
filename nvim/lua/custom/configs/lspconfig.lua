local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local basic_servers = {
  "html",
  "cssls",
  "yamlls",
  "bashls",
  "pyright",
  "terraformls",
  "terraform_lsp",
  "tflint"
}

-- Loop through "basic_servers" and just do a basic setup with on_attach and
-- capabilities attributes
for _, lsp in ipairs(basic_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.helm_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "helm", "yaml" },
  root_dir = util.root_pattern("Chart.yaml", "templates", ".git")
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
