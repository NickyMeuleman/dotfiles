return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp"
  },
  config = function()
    require("otter").setup({
      lsp = {
        hover = true,
        diagnostics = true,
        completion = true,
      },
      buffers = {
        set_filetype = true,
      },
    })
  end,
}
