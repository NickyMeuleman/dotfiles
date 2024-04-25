return {
	"lukas-reineke/headlines.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local shared_opts = {
			dash_string = "-",
			quote_string = "┃",
			bullets = { "◉", "○", "✸", "✿" },
			dash_highlight = "Dash",
			quote_highlight = "Quote",
			codeblock_highlight = "CodeBlock",
			headline_highlights = {
				"Headline1",
				"Headline2",
				"Headline3",
				"Headline4",
				"Headline5",
				"Headline6",
			},
			bullet_highlights = {
				"Headline1",
				"Headline2",
				"Headline3",
				"Headline4",
				"Headline5",
				"Headline6",
			},
			-- fat headlines are nice, but make it too hard to see blank surrounding lines
			fat_headlines = false,
		}

		local markdown_specific_opts = {
			treesitter_language = "markdown",
			-- I use html tags in block quotes sometimes, so I added that query
			query = vim.treesitter.query.parse(
				"markdown",
				[[
          (atx_heading [
              (atx_h1_marker)
              (atx_h2_marker)
              (atx_h3_marker)
              (atx_h4_marker)
              (atx_h5_marker)
              (atx_h6_marker)
          ] @headline)

          (thematic_break) @dash

          (fenced_code_block) @codeblock

          (block_quote_marker) @quote
          (block_quote (paragraph (inline (block_continuation) @quote)))
          (block_quote (paragraph (block_continuation) @quote))
          (block_quote (block_continuation) @quote)

          (block_quote (html_block (block_continuation) @quote))
         ]]
			),
		}

		local full_markdown_opts = vim.tbl_extend("force", shared_opts, markdown_specific_opts)

		require("headlines").setup({
			markdown = full_markdown_opts,
			mdx = full_markdown_opts,
			markdoc = full_markdown_opts,
		})
	end,
}
