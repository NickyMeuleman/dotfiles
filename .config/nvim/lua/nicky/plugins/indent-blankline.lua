return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup({
      enabled = true,
      indent = { char = "▏" },
    })
  end
}
