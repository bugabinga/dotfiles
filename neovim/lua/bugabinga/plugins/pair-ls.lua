return {
	'stevearc/pair-ls.nvim',
	cmd = { 'Pair', 'PairConnect', },
	opts = {
		cmd = { 'pair-ls', 'lsp', },
		-- cmd = { "pair-ls", "lsp", "-port", "8080" },
		-- cmd = { "pair-ls", "lsp", "-port", "8081" },
		-- cmd = { "pair-ls", "lsp", "-signal", "wss://localhost:8080" },
		-- cmd = { "pair-ls", "lsp", "-forward", "wss://localhost:8080" },
	},
}
