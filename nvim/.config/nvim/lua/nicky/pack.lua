vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/refractalize/oil-git-status.nvim",
    "https://github.com/dmtrKovalenko/fff",
    "https://github.com/folke/snacks.nvim",
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff') end
      require('fff.download').download_or_build_binary()
    end
  end,
})
