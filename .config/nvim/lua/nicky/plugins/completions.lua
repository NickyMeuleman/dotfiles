return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets", -- collection of snippets 
      }
    },
    'saadparwaiz1/cmp_luasnip', -- source for luasnip
    'hrsh7th/cmp-buffer', -- source for buffer words
    'hrsh7th/cmp-nvim-lsp', -- source for lsp
  },
  config = function()
    local cmp = require'cmp'

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      -- cmp.config.sources is a tuple that holds tuples
      -- the top layer determines the priority of groups
      -- the order within a group determines the order in the completion results.
      -- only the group with the higherst priority will be shown
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
          { name = 'buffer' },
        })
    })
  end
}
