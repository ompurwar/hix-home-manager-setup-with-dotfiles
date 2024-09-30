-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls","ts_ls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
--

-- Setup for TypeScript and JavaScript LSP (tsserver)
-- lspconfig.tsserver.setup {
--   on_attach = function(client, bufnr)
--     -- Disable tsserver formatting if you're using null-ls for formatting
--     -- client.server_capabilities.documentFormattingProvider = false
--   end,
--
--   -- Configure Bun as the runtime for TypeScript and JavaScript
--   init_options = {
--     hostInfo = "bun",
--   },
--
--   -- Specify Bun's node_modules path for TypeScript
--   settings = {
--     typescript = {
--       tsdk = "/path/to/bun/node_modules/typescript/lib" -- Update this path to point to Bun's TypeScript
--     }
--   }
-- }
