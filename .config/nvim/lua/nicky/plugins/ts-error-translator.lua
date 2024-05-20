return {
	"dmmulroy/ts-error-translator.nvim",
	event = { "LspAttach *{.ts,.tsx,.js,.jsx,.astro,.svelte}" },
	config = function()
		require("ts-error-translator").setup()
	end,
}
