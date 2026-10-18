-- https://cmp.saghen.dev/recipes.html#completion-menu-drawing
local function get_mini_icon(ctx)
  if ctx.source_name == "Path" then
    local is_unknown_type = vim.tbl_contains(
        { "link", "socket", "fifo", "char", "block", "unknown" },
        ctx.item.data.type
    )
    local mini_icon, mini_hl, _ = require("mini.icons").get(
        is_unknown_type and "os" or ctx.item.data.type,
        is_unknown_type and "" or ctx.label
    )
    if mini_icon then
        return mini_icon, mini_hl
    end
  end
  local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
  return mini_icon, mini_hl
end

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
	completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _ = get_mini_icon(ctx)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx)
              return hl
            end,
          },
          kind = {
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx)
              return hl
            end,
          }
        }
      }
    }
  },
	signature = { enabled = true },
  cmdline = { completion = { menu = { auto_show = true } } }
})
