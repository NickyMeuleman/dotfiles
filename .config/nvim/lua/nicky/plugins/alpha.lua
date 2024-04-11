return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local alpha = require("alpha")
    local startify = require("alpha.themes.startify")

    startify.config.layout = {
      { type = "padding", val = 1 },
      startify.section.header,
      { type = "padding", val = 2 },
      startify.section.top_buttons,
      startify.section.mru_cwd,
      startify.section.mru,
      { type = "padding", val = 1 },
      startify.section.bottom_buttons,
      { type = "padding", val = 1 },
      startify.section.footer,
    }

    startify.section.header.val = {
      [[ ███╗   ██╗██╗ ██████╗██╗  ██╗██╗   ██╗██╗   ██╗██╗███╗   ███╗  ]],
      [[ ████╗  ██║██║██╔════╝██║ ██╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║  ]],
      [[ ██╔██╗ ██║██║██║     █████╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║  ]],
      [[ ██║╚██╗██║██║██║     ██╔═██╗   ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
      [[ ██║ ╚████║██║╚██████╗██║  ██╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
      [[ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
    }

    startify.section.header.opts.hl = "AlphaHeader"

    local cur_dir = vim.fn.getcwd()

    startify.section.mru_cwd.val = {
      { type = "padding", val = 1 },
      {
        type = "text",
        val = "Recent in " .. cur_dir,
        opts = {
          hl = "AlphaHeaderLabel",
          shrink_margin = false
        }
      },
      { type = "padding", val = 1 },
      {
        type = "group",
        val = function()
          return { startify.mru(0, cur_dir, 5) }
        end,
        opts = { shrink_margin = false },
      }
    }

    startify.section.mru.val = {
      { type = "padding", val = 1 },
      {
        type = "text",
        val = "Recent",
        opts = {
          hl = "AlphaHeaderLabel",
          shrink_margin = false
        }
      },
      { type = "padding", val = 1 },
      {
        type = "group",
        val = function()
          return { startify.mru(5, nil, 5) }
        end,
        opts = { shrink_margin = false },
      }
    }

    alpha.setup(startify.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha footer",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime)

        local version = vim.version()
        local dev = ""
        if version.prerelease == "dev" then
          dev = "-dev+" .. version.build
        else
          dev = ""
        end

        local time = vim.fn.strftime("%H:%M:%S")
        local date = vim.fn.strftime("%d-%m-%Y")

        local line1 = " v" .. version.major .. "." .. version.minor .. "." .. version.patch .. dev
        local line2 = "Loaded " .. stats.loaded .. " plugins  in " .. ms .. "ms"
        local line3 = " " .. date ..  "  " .. time

        startify.section.footer.val = {
          { type = "text", val = line1, opts = { hl = "AlphaFooter" } },
          { type = "text", val = line2, opts = { hl = "AlphaFooter" } },
          { type = "text", val = line3, opts = { hl = "AlphaFooter" } },
        }

        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end
}
