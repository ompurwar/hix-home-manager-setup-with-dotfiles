return {
  -- Conform: Formatting tool
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- Uncomment this to enable format-on-save
    opts = require("configs.conform"),  -- Assuming configs.conform exists and is correctly set up
  },

  -- Neovim LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")  -- Make sure configs.lspconfig exists and is properly configured
    end,
  },

  -- Neorg: Notes and organization tool
 {
  "nvim-neorg/neorg",
  lazy = true,  -- Defer loading until needed
  version = "main",  -- Use the latest stable version
  event = "BufReadPost *.norg",  -- Load Neorg when opening a .norg file
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.summary"] = {},
        ["core.completion"] = {
            config = {
              engine = "nvim-cmp"
            }
          },
        ["core.dirman"] = {
          config = {
            workspaces = {
              wyzr = "/home/omp/notes/wrzr",
              personal = "/home/omp/notes/personal"
            },
          },
        },
      },
    })
    end,
  },

  -- Treesitter: Syntax highlighting and code parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- Automatically update parsers
    opts = {
      ensure_installed = {  -- Install parsers for these languages
        "vim", "lua", "vimdoc", "norg", "html", "css", "typescript", "javascript"
      },
      highlight = { enable = true },  -- Enable highlighting for installed languages
    },
  },
}

