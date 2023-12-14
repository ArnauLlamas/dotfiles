local mason = require("mason")
local options = {
	ensure_installed = { -- not an option from mason.nvim
		-- Python
		"black",
		"debugpy",
		"mypy",
		"ruff",
		-- Go
		"gofumpt",
		"goimports-reviser",
		"golines",
		"gomodifytags",
		"delve",
		"iferr",
		"impl",
		-- Others
		"hadolint",
		"shfmt",
		"stylua",
		"trivy",
		"actionlint",
		"yamllint",
		"yamlfmt",
		"shfmt",
		"shellcheck",
		"prettier",
		"rustywind",
	},
	max_concurrent_installers = 10,
}

mason.setup(options)

vim.api.nvim_create_user_command("MasonInstallUtils", function()
	vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})
