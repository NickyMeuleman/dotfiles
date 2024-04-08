return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      -- install grammars for these languages so TS can parse them into a correct AST
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "gitignore",
        "graphql",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "prisma",
        "query",
        "rust",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      -- syntax highlighting based on TS grammars
      highlight = { enable = true },
      -- indentation logic uses ths TS grammars
      indent = { enable = true },
    })
  end
}
