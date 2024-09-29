vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "norg" }, -- Add "norg" to the list of parsers to ensure it's installed
--   highlight = {
--     disable = {"norg"},
--     enable = true,
--   },
-- }

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Create a custom command to call Bieye
vim.api.nvim_create_user_command(
  'Bieye',
  function()
    -- Get the current file path
    local file = vim.fn.expand("%:p")
    -- Run Bieye on the current file in a terminal buffer
    vim.cmd('write | silent !cat ' .. file .. ' | bieye | tee ' .. file .. '.bieye && sleep 5')
    vim.cmd('edit ' .. file .. '.bieye')  -- Open the bieye output
  end,
  { nargs = 0 }
)

vim.api.nvim_set_keymap('n', '<leader>b', ':Bieye<CR>', { noremap = true, silent = true })

