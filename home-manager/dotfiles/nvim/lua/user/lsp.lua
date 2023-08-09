-- require("lspconfig")["rust_analyzer"].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = {
--     "/nix/store/3lnnc0ag6hp60xvzhb4cxh6wbzh8anxs-rust-analyzer-2023-05-15/bin/rust-analyzer",
--   }
-- }

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
  vim.keymap.set("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end)
  vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end)
  vim.keymap.set("n", "<leader>lca", function() vim.lsp.buf.code_action() end)
  vim.keymap.set("n", "<leader>lrr", function() vim.lsp.buf.references() end)
  vim.keymap.set("n", "<leader>lrn", function() vim.lsp.buf.rename() end)
  vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end)
end)

-- lsp.ensure_installed({
--   'rust_analyzer',
--   'lua_ls',
-- })

lsp.setup_servers({"rust_analyzer", "lua_ls"})

-- Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load()
require('luasnip.loaders.from_lua').lazy_load()

cmp.setup({
  sources = {
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }
})
