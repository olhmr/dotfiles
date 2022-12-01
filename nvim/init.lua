--:============================================================================
-- basic
--=============================================================================

--:----------------------------------------------------------------------------
-- Startup optimisation
-------------------------------------------------------------------------------
vim.g['python3_host_prog'] = '~/.config/nvim/python-env/env/bin/python3'


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

-- enable line numbers in netrw
vim.g['netrw_bufsettings'] = 'noma nomod nu rnu nobl nowrap ro'

-- do not include netrw browser buffer in altfile
-- this means c-^ will ignore it
vim.g['netrw_altfile'] = 1

vim.opt.showtabline = 2 -- always show tabline


--:----------------------------------------------------------------------------
-- Miscellaneous
-------------------------------------------------------------------------------
-- keybinds to copy name and path of file to clipboard
vim.keymap.set('n', '<leader>cs', ':let @*=expand("%:t")<CR>')
vim.keymap.set('n', '<leader>cl', ':let @*=expand("%:p")<CR>')

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
Plug 'morhetz/gruvbox' -- colorscheme
Plug 'tpope/vim-commentary' -- manage comments
Plug 'tpope/vim-fugitive' -- git
Plug 'tpope/vim-surround' -- managing e.g. parentheses
Plug 'tpope/vim-vinegar' -- directory navigation
Plug 'nvim-lua/plenary.nvim' -- for telescope
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' }) -- fuzzy finder
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
-- begin autocomplete with nvim-cmp and vim-vsnip
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
-- end autocomplete with nvim-cmp and vim-vsnip
Plug 'lepture/vim-jinja' -- for dbt syntax to work

vim.call('plug#end')


--:----------------------------------------------------------------------------
-- gruvbox
-------------------------------------------------------------------------------
vim.cmd('colorscheme gruvbox') -- set colorscheme
vim.g['gruvbox_contrast_dark'] = 'hard' -- make darker
vim.opt.background = 'dark' -- set background dark, must be after colorscheme is loaded


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
-- creating a new window
vim.keymap.set('t', '<c-w>n', '<c-\\><c-n>')

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
      \          [ 'linter_warnings', 'linter_errors', 'linter_ok' ] ]
  \ },
  \ 'component_function': {
    \ 'fugitive': 'FugitiveHead',
    \ 'gitgutter': 'LightLineGitGutter',
    \ 'vista': 'NearestMethodOrFunction'
  \ },
  \ 'component_expand': {
    \ 'readonly': 'LightLineReadonly',
    \ 'linter_warnings': 'LightlineLinterWarnings',
    \ 'linter_errors': 'LightlineLinterErrors',
    \ 'linter_ok': 'LightlineLinterOK'
  \ },
  \ 'component_type': {
    \ 'readonly': 'error',
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ 'linter_ok': 'ok'
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

" Below three from here: https://github.com/statico/dotfiles/blob/45aa1ba59b275ef72d8e5cc98f8d6aa360518e00/.vim/vimrc#L412
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  return l:counts.total == 0 ? '✓' : ''
endfunction

" From https://github.com/maximbaz/lightline-ale/blob/master/plugin/lightline/ale.vim
augroup lightline#ale
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
augroup end
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


--:----------------------------------------------------------------------------
-- nvim-cmp / autocomplete
-------------------------------------------------------------------------------
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
-- set up nvim-cmp.
local cmp = require'cmp'
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
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
