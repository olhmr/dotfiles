--:============================================================================
-- basic
--=============================================================================

--:----------------------------------------------------------------------------
-- Startup optimisation
-------------------------------------------------------------------------------
vim.g['python3_host_prog'] = '~/.config/nvim/python-env/env/bin/python3'
vim.g['loaded_ruby_provider'] = 0
vim.g['loaded_node_provider'] = 0
vim.g['loaded_perl_provider'] = 0


--:----------------------------------------------------------------------------
-- Initial
-------------------------------------------------------------------------------
vim.g.mapleader = ','
vim.g.maplocalleader = '\\'


--:----------------------------------------------------------------------------
-- Color and Interface
-------------------------------------------------------------------------------
vim.opt.scrolloff = 7 -- number of lines to keep on screen when scrolling
vim.opt.shortmess:append 'c' -- always show position
vim.opt_global.shortmess:remove("F") -- for nvim-metals
vim.opt.ruler = true
vim.opt.cmdheight = 2 -- height of command bar
vim.opt.foldcolumn = '0' -- amount of extra margin to the left
vim.opt.cc = '80' -- add vertical at 80
vim.opt.hidden = true -- hide buffers when abandoned
vim.opt.lazyredraw = true -- don't redraw while executing macros (performance)
vim.opt.mat = 2 -- how many tenths of a second to blink when matching brackets
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smarttab = true -- be smart when using tabs
vim.opt.shiftwidth = 2 -- 1 tab == 2 spaces
vim.opt.tabstop = 2 -- 1 tab == 2 spaces
vim.opt.updatetime = 250 -- quicker response for things like gitgutter
vim.opt.wildignore = {'*.o', '*~', '*.pyc', '*/.git/*', '*/.hg/*', '*/.svn/*', '*/.DS_Store', '*/env/*'} -- ignore compiled files in wildmode
vim.opt.backspace = {'eol', 'start', 'indent'} -- configure backspace so it works as expected
vim.opt.whichwrap:append 'h' -- use h to go to previous line
vim.opt.whichwrap:append 'l' -- use l to go to next line
vim.opt.tm = 500 -- how long to wait for command input
vim.opt.number = true -- enable line numbers
vim.opt.relativenumber = true -- combined with number, enables hybdrid
vim.opt.signcolumn = 'yes' -- always show signcolumn
vim.opt.listchars = "tab:> ,trail:-,nbsp:+,space:·,multispace:|···,eol:↴"
vim.opt.list = true -- show the above


--:----------------------------------------------------------------------------
-- Searching and Regex
-------------------------------------------------------------------------------
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- unless uppercase are in the search string
vim.opt.magic = true -- for regexprs turn magic on
vim.opt.wildignorecase = true
vim.opt.wildmode = {'longest:full', 'full'}
vim.opt.history = 500

vim.keymap.set('n', '<leader><cr>', ':noh<cr>', { silent = true}) -- keybind to disable highlight


--:----------------------------------------------------------------------------
-- Reading, Saving, and History
-------------------------------------------------------------------------------
-- delete trailing whitespace on save
-- this currently does not work as intended if the search was done using *
-- to search for the word under the cursos, as that appears to store the
-- search in a different way
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    local old_query = vim.fn.getreg('/')
    vim.api.nvim_command([[silent! %s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
    vim.fn.setreg('/', old_query)
  end
})

-- enable undo even after closing buffer
vim.opt.undofile = true

-- return to previous cursor position when re-opening buffer
vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = { "*" },
  command = [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]],
})


--:----------------------------------------------------------------------------
-- Windows, Tabs, Buffers, and Navigation
-------------------------------------------------------------------------------
-- move between windows
vim.keymap.set('n', '<c-j>', '<c-W>j')
vim.keymap.set('n', '<c-k>', '<c-W>k')
vim.keymap.set('n', '<c-h>', '<c-W>h')
vim.keymap.set('n', '<c-l>', '<c-W>l')

-- manage tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<cr>')
vim.keymap.set('n', '<leader>to', ':tabonly<cr>')
vim.keymap.set('n', '<leader>tc', ':tabclose<cr>')
vim.keymap.set('n', '<leader>tm', ':tabmove')

-- toggle between current and last tab
vim.g['lasttab'] = 1
vim.keymap.set('n', '<leader>tl', ':exe "tabn ".g:lasttab<cr>')
vim.api.nvim_create_autocmd({ "TabLeave" }, {
  pattern = { "*" },
  command = [[let g:lasttab = tabpagenr()]]
})

-- open a new tab with the current buffers path
vim.keymap.set('n', '<leader>te', ':tabedit <c-r>=expand("%:p:h")<cr>')

-- remap 0 to first non-blank char - use | for other behaviour
vim.keymap.set('n', '0', '^')
vim.keymap.set('o', '0', '^')

-- enable line numbers in netrw
vim.g['netrw_bufsettings'] = 'noma nomod nu rnu nobl nowrap ro'

-- do not include netrw browser buffer in altfile
-- this means c-^ will ignore it
vim.g['netrw_altfile'] = 1

vim.opt.showtabline = 2 -- always show tabline

-- allow this to work as expected while I troubleshoot why the caps rebind to
-- control isn't working as expected
vim.keymap.set('i', '<Home>', '<c-[>')


--:----------------------------------------------------------------------------
-- Miscellaneous
-------------------------------------------------------------------------------
-- keybinds to copy name and path of file to clipboard
vim.keymap.set('n', '<leader>cs', ':let @*=expand("%:t")<CR>')
vim.keymap.set('n', '<leader>cl', ':let @*=expand("%:p")<CR>')

-- open path in github, assuming vim was opened from the project root
-- requires the gh cli
vim.keymap.set('n', '<leader><s-g>', ':execute "!gh browse" expand("%") "-b" system("git rev-parse --abbrev-ref HEAD")<CR>')

-- switch current working directory to open buffer
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<cr>:pwd<cr>')

-- yank, paste, and delete using system clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>d', '"+d')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>d', '"+d')


--:============================================================================
-- Filetypes
--=============================================================================

--:----------------------------------------------------------------------------
-- dbt
-------------------------------------------------------------------------------
-- inspiration: https://github.com/jgillies/vim-dbt
-- inspiration: https://github.com/ivanovyordan/dbt.vim
-- inspiration: https://discourse.getdbt.com/t/syntax-highlighting-sql-linting/15/3
-- not figured out how to do this in lua yet
vim.cmd [[
  autocmd FileType dbt setlocal commentstring={#%s#}
  au BufNewFile,BufRead *.sql set ft=dbt
  autocmd FileType sql setlocal commentstring=/*%s*/
]]
-- disable sql drilldown keymap replacing arrow keys in sql files
-- see https://superuser.com/questions/139620/lost-left-right-cursor-keys-in-vim-insert-mode
vim.g['omni_sql_no_default_maps'] = 1


--:----------------------------------------------------------------------------
-- avro / avro schema (avsc)
-------------------------------------------------------------------------------
vim.cmd [[
  au BufNewFile,BufRead *.avsc set ft=json
]]


--:============================================================================
-- Plugins
--=============================================================================

--:----------------------------------------------------------------------------
-- vim-plug
-------------------------------------------------------------------------------
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter' -- git info on the side
Plug 'itchyny/lightline.vim' -- status bar
Plug 'jeetsukumaran/vim-indentwise' -- nice motions for navigating indents
Plug 'jlanzarotta/bufexplorer' -- manage buffers
Plug 'kassio/neoterm' -- nice terminal integration
Plug 'sainnhe/gruvbox-material' -- colorscheme
Plug 'tpope/vim-commentary' -- manage comments
Plug 'tpope/vim-fugitive' -- git
Plug 'tpope/vim-surround' -- managing e.g. parentheses
Plug 'tpope/vim-vinegar' -- directory navigation
Plug 'nvim-lua/plenary.nvim' -- for telescope and nvim-metals
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' }) -- fuzzy finder
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
-- begin autocomplete with nvim-cmp and vim-vsnip
  -- begin LSP-specific config
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'williamboman/mason.nvim' -- lsp install
Plug 'williamboman/mason-lspconfig.nvim' -- links mason to lspconfig
Plug 'scalameta/nvim-metals' -- scala LSP
Plug 'mfussenegger/nvim-dap' -- scala debugging
Plug 'towolf/vim-helm' -- helm LSP, required on top of mason
  -- end LSP-specific config
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind.nvim' -- icons
-- end autocomplete with nvim-cmp and vim-vsnip
Plug 'lepture/vim-jinja' -- for dbt syntax to work
Plug 'kshenoy/vim-signature' -- handling marks
Plug 'hashivim/vim-terraform' -- terraform syntax highlight + commands
Plug 'lukas-reineke/indent-blankline.nvim' -- indentation guides
Plug 'vimwiki/vimwiki' -- personal knowledge management
Plug 'rust-lang/rust.vim'
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'

vim.call'plug#end'


--:----------------------------------------------------------------------------
-- gruvbox-material
-------------------------------------------------------------------------------
vim.g['gruvbox_material_visual'] = 'reverse' -- visual line selection
vim.g['gruvbox_material_better_performance'] = 1
vim.g['gruvbox_material_disable_italic_comment'] = 1
vim.g['gruvbox_material_enable_bold'] = 1
vim.g['gruvbox_material_foreground'] = 'material'

-- add highlightgroups for nvim-cmp completion
vim.cmd [[
  function! s:gruvbox_material_custom() abort
    highlight! link CmpItemAbbrDeprecated Grey
    highlight! link CmpItemAbbrMatch GreyBold
    highlight! link CmpItemAbbrMatchFuzzy GreyBold
    highlight! link CmpItemMenu GreyItalic

    highlight! link CmpItemKindField Red
    highlight! link CmpItemKindProperty Red
    highlight! link CmpItemKindEvent Red

    highlight! link CmpItemKindText Aqua
    highlight! link CmpItemKindEnum Aqua
    highlight! link CmpItemKindKeyword Aqua

    highlight! link CmpItemKindConstant Yellow
    highlight! link CmpItemKindConstructor Yellow
    highlight! link CmpItemKindReference Yellow

    highlight! link CmpItemKindFunction Purple
    highlight! link CmpItemKindStruct Purple
    highlight! link CmpItemKindClass Purple
    highlight! link CmpItemKindModule Purple
    highlight! link CmpItemKindOperator Purple

    highlight! link CmpItemKindVariable Aqua
    highlight! link CmpItemKindFile Aqua

    highlight! link CmpItemKindUnit Red
    highlight! link CmpItemKindSnippet Red
    highlight! link CmpItemKindFolder Red

    highlight! link CmpItemKindMethod Purple
    highlight! link CmpItemKindValue Purple
    highlight! link CmpItemKindEnumMember Purple

    highlight! link CmpItemKindInterface Aqua
    highlight! link CmpItemKindColor Aqua
    highlight! link CmpItemKindTypeParameter Aqua
  endfunction

  augroup GruvboxMaterialCustom
    autocmd!
    autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
  augroup END
]]

vim.cmd('colorscheme gruvbox-material') -- set colorscheme


--:----------------------------------------------------------------------------
-- BufExplorer
-------------------------------------------------------------------------------
vim.g['bufExplorerDefaultHelp'] = 0
vim.g['bufExplorerShowRelativePath'] = 1
vim.g['bufExplorerSortBy'] = 'name'
vim.keymap.set('n', '<leader>o', ':BufExplorer<cr>')


--:----------------------------------------------------------------------------
-- neoterm
-------------------------------------------------------------------------------
-- in terminal mode only, override ctrl-w n to exit insert mode instead of
-- creating a new window (also include <c-w><c-n> for convenience)
vim.keymap.set('t', '<c-w>n', '<c-\\><c-n>')
vim.keymap.set('t', '<c-w><c-n>', '<c-\\><c-n>')

-- use same window movement from terminal as between windows
vim.keymap.set('t', '<c-w>h', '<c-\\><c-n><c-w>h')
vim.keymap.set('t', '<c-w>j', '<c-\\><c-n><c-w>j')
vim.keymap.set('t', '<c-w>k', '<c-\\><c-n><c-w>k')
vim.keymap.set('t', '<c-w>l', '<c-\\><c-n><c-w>l')

-- BigQuery
vim.keymap.set('n', '<leader>tq', ":exec('T cat % | bq query --max_rows=100')")
vim.keymap.set('n', '<leader>td', ":exec('T cat % | bq_dry')<CR>")
vim.keymap.set('n', '<leader>tf', ":exec('T cat % | bq query --format=csv --max_rows=1000000 > output.csv')")

-- REPL
-- not validated yet
vim.g['neoterm_repl_python'] = 'python3 -m IPython' -- this requires any virtual environment to already be activated
vim.g['neoterm_repl_enable_ipython_paste_magic'] = 1
vim.g['neoterm_bracketed_paste'] = 0
vim.keymap.set('n', '<leader>ts', '<Plug>(neoterm-repl-send)')

vim.keymap.set('n', '<leader>sf', ':TREPLSendFile<CR>')
vim.keymap.set('n', '<leader>sl', ':TREPLSendLine<CR>')
vim.keymap.set('v', '<leader>sl', ':TREPLSendSelection<CR>')


-- don't print shift-space escape sequence in terminal mode, just print space
vim.keymap.set('t', '<s-space>', '<space>')


--:----------------------------------------------------------------------------
-- gitgutter
-------------------------------------------------------------------------------
vim.g['gitgutter_map_keys'] = 0 -- don't use gitgutter-provided keymaps

-- for use in lightline
vim.cmd [[
  function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
      return printf('+%d ~%d -%d', a, m, r)
  endfunction
]]

-- set colors
vim.cmd [[
  highlight GitGutterAdd    guifg='green' ctermfg=2
  highlight GitGutterChange guifg='yellow' ctermfg=3
  highlight GitGutterDelete guifg='red' ctermfg=1
]]


--:----------------------------------------------------------------------------
-- lightline
-------------------------------------------------------------------------------
-- status line / tabline
-- inspiration here: https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc
vim.opt.showmode = false -- don'y show -- INSERT -- etc. below lightline

-- set up lightline options
-- should migrate this to lua eventually
vim.cmd [[
let g:lightline = {
  \ 'colorscheme': 'srcery_drk',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
    \ 'left': [ [ 'mode', 'paste' ],
      \         [ 'absolutepath', 'readonly', 'fugitive', 'modified', 'gitgutter', 'vista' ] ],
    \ 'right': [ [ 'percent', 'lineinfo' ],
      \          [ 'fileformat', 'fileencoding', 'filetype' ],
      \          [ 'metals_status' ] ]
  \ },
  \ 'component_function': {
    \ 'fugitive': 'FugitiveHead',
    \ 'gitgutter': 'LightLineGitGutter',
    \ 'vista': 'NearestMethodOrFunction',
    \ 'metals_status': 'MetalsStatus'
  \ },
  \ 'component_expand': {
    \ 'readonly': 'LightLineReadonly'
  \ },
  \ 'component_type': {
    \ 'readonly': 'error'
  \ }
\ }

function! LightLineReadonly()
  " This need to be a function to allow expansion and setting colour
  if &readonly
    return "RO"
  else
    return ""
  endif
endfunction

function! LightLineGitGutter()
  let symbols = [
    \ g:gitgutter_sign_added,
    \ g:gitgutter_sign_modified,
    \ g:gitgutter_sign_removed
    \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
        call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" From https://github.com/scalameta/nvim-metals/discussions/236
function! MetalsStatus() abort
  return get(g:, 'metals_status', '')
endfunction
]]


--:----------------------------------------------------------------------------
-- telescope
-------------------------------------------------------------------------------
require('telescope').load_extension('fzf')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-f>', function() builtin.find_files({ hidden = true }) end, {}) -- find files
vim.keymap.set('n', '<leader>g', builtin.live_grep, {}) -- find inside files
vim.keymap.set('n', '<leader>fh', function() builtin.oldfiles({ only_cwd = true }) end, {}) -- find recent files
vim.keymap.set('n', '<leader>fc', builtin.git_bcommits, {}) -- find commits in current file with diffs

-- inspiration: https://www.reddit.com/r/neovim/comments/w4qsju/toggle_preview_in_telescope/
require('telescope').setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        width = 0.9,
      },
    },
    preview = {
      hide_on_startup = true
    },
    file_ignore_patterns = { '.git/', '.venv' },
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    mappings = {
      i = {
        ['<c-p>'] = require('telescope.actions.layout').toggle_preview
      },
    },
  }
}


--:----------------------------------------------------------------------------
-- vim-vsnip
-------------------------------------------------------------------------------
vim.g['vsnip_snippet_dir'] = '~/.config/nvim/.vsnip'
-- jump forward or backward
vim.cmd [[
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]


--:----------------------------------------------------------------------------
-- indent-blankline
-------------------------------------------------------------------------------
require("ibl").setup {}


--:----------------------------------------------------------------------------
-- Autocomplete - nvim/cmp
-------------------------------------------------------------------------------
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
-- set up nvim-cmp.
local cmp = require'cmp'
local lspkind = require'lspkind'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "text_symbol",
      menu = ({
        buffer = "[Buffer]",
        vsnip = "[vsnip]",
      })
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items. Set `select` to `true` to accept currently selected item / the first item.
    ["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, {"i", "s"}),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, {"i", "s"}),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


--:----------------------------------------------------------------------------
-- LSP - generic
-------------------------------------------------------------------------------
-- mostly copied from https://gist.github.com/VonHeikemen/8fc2aa6da030757a5612393d0ae060bd
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<leader>cr', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

vim.opt.winborder = 'single'

require('mason').setup({})
require('mason-lspconfig').setup({})

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)


--:----------------------------------------------------------------------------
-- LSP - python, lua, golang, terraform, bash, rust
-------------------------------------------------------------------------------
-- Set up lspconfig.
-- this is handled by mason-lspconfig


--:----------------------------------------------------------------------------
-- LSP - scala / nvim-metals
-------------------------------------------------------------------------------
-- from https://github.com/scalameta/nvim-metals/discussions/39
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})


--:----------------------------------------------------------------------------
-- vim-wiki
-------------------------------------------------------------------------------
vim.g.vimwiki_list = {{path = '~/workspace/trustly-wiki', syntax = 'markdown', ext = '.md'}}
vim.g.vimwiki_global_ext = 0
vim.keymap.set('i', '<c-tab>', '<Plug>VimwikiTableNextCell')
vim.keymap.set('i', '<a-tab>', '<Plug>VimwikiTablePrevCell')


--:----------------------------------------------------------------------------
-- github copilot
-------------------------------------------------------------------------------
-- by default copilot uses M in the mappings, which doesn't work well on mac
-- we also override the dismiss so that we can have more sensible mappings for
-- next/previous, as that uses <M-]> by default
vim.keymap.set('i', '<C-=>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<C-+>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-_>', '<Plug>(copilot-previous)')

-- using the right arrow to complete feels more natural since we have ghost
-- text, although leaving the tab for now to see which I prefer
vim.cmd [[
  imap <silent><script><expr> <Right> copilot#Accept("")
]]
vim.g.copilot_no_tab_map = true

-- chat functionality
require("CopilotChat").setup {
  model = "claude-3.7-sonnet-thought"
}
vim.keymap.set('n', '<leader>cc', ':CopilotChatToggle<CR>')
vim.keymap.set('n', '<leader>cp', ':CopilotChatPrompts<CR>')
vim.keymap.set('v', '<leader>cm', ':CopilotChat<CR>')
