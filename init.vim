call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'

"lsp
Plug 'neovim/nvim-lspconfig'

"autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

"rust-analyzer
Plug 'simrat39/rust-tools.nvim'

"debugging
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'

"html
Plug 'mattn/emmet-vim'

call plug#end()

set tabstop=4 shiftwidth=4 expandtab
set mouse=a
set relativenumber
set textwidth=78
set nowrap
set formatoptions-=t

"neovim theme
colorscheme gruvbox

let g:rust_recommended_style = 0
let g:lightline = { 'colorscheme': 'gruvbox' }

"html
let g:user_emmet_leader_key='<C-X>'

"rust utilities
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <C-f> <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> ti    <cmd>RustToggleInlayHints<CR>

nnoremap <A-c> :!cargo check --all-features<CR>

set completeopt=menu,menuone,noselect

"my custom commands
fu! HtmlToRegex()
    :%s/\//\\\//g
    :%s/    /\\t/g
    :%s/\n/\\r/g
    normal $xx
endf

command! HtmlToRegex call HtmlToRegex()

lua << EOF
-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('rust-tools').setup({
    tools = {
        autoSetHints = false,
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true
                },
                rustfmt = {
                    extraArgs = { "+nightly" }
                },
            }
        },
        capabilities = capabilities
    },
})

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}
-- {
--   { name = 'buffer' },
-- }
)})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
-- sources = cmp.config.sources({
--   { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
-- }, {
--   { name = 'buffer' },
-- })
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = {
--   { name = 'buffer' }
-- }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = cmp.config.sources({
--   { name = 'path' }
-- }, {
--   { name = 'cmdline' }
-- })
-- })
EOF
