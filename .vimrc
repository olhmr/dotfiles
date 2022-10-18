"=:==========================================================================="
" basic                                                                       "
"============================================================================="

"-:---------------------------------------------------------------------------"
" Startup optimisation                                                        "
"-----------------------------------------------------------------------------"
let g:loaded_ruby_provider=0
let g:loaded_python_provider=0
let g:python_host_skip_check=1
let g:python3_host_skip_check=1
let g:python3_host_prog='/usr/bin/python3'
let g:node_host_prog='/usr/local/bin/node'


"-:---------------------------------------------------------------------------"
" Initial                                                                     "
"-----------------------------------------------------------------------------"
set nocompatible

" Define leader
let mapleader = ","
let maplocalleader = "\\"

" Enable filetype plugins
filetype plugin on
filetype indent on


"-:---------------------------------------------------------------------------"
" Color and Interface                                                         "
"-----------------------------------------------------------------------------"
" Note: for iTerm2 I use gruvbox but with cursor background and cursor
" highlight colours swapped, to prevent cursor from becoming invisible
colorscheme gruvbox " ~/.vim/colors/gruvbox.vim, https://github.com/morhetz/gruvbox
let g:gruvbox_contrast_dark='hard'

" Enabling both number and relative number produces hybrid number
set number
set relativenumber 

" Toggle cursorline
:autocmd InsertEnter * set cul " Enable cursorline when entering insert mode
:autocmd InsertLeave * set nocul " Disable cursorline when existing insert mode

" Set how many lines to keep on the screen when scrolling
set scrolloff=7
set shortmess+=c
set ruler " Always show position
set cmdheight=2 " Height of command bar
set showmatch " Show matching brackets when text indicator is over them
set foldcolumn=0 " Amount of extra margin to the left
set signcolumn=number " Use same column for signs and numbers
set cc=80 " Add vertical at 80


"-:---------------------------------------------------------------------------"
" Miscellaneous                                                               "
"-----------------------------------------------------------------------------"
set hidden " Hide buffers when abandoned
set lazyredraw " Don't redraw while executing macros (good performance config)
set mat=2 " How many tenths of a second to blink when matching brackets

" Basic tab setup
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs
set shiftwidth=2 " 1 tab == 2 spaces
set tabstop=2 " 1 tab == 2 spaces

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Ignore whitespace in diff
set diffopt+=iwhite
set diffexpr=DiffW()
function DiffW()
  let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-w " " TODO: check if this should be changed to -b
   endif
   silent execute "!diff -a --binary " . opt .
     \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction

set updatetime=250 " Quicker response for things like gitgutter

" Ignore compiled files in wildmode
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/env/*

" Configure backspace so it acts as it should act
" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=eol,start,indent 
set whichwrap+=<,>,h,l,[,]

" No annoying sound on errors
set noerrorbells
set novisualbell
set belloff=all
set t_vb=
set tm=500

set encoding=utf8 " Set utf8 as standard encoding
set ffs=unix,dos,mac " Use Unix as the standard file type

" Copy name of file
nmap ,cs :let @*=expand("%:t")<CR>
nmap ,cl :let @*=expand("%:p")<CR>

" Yank, paste, and delete using system clipboard
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>d "+d


"-:---------------------------------------------------------------------------"
" Searching and Regex                                                         "
"-----------------------------------------------------------------------------"
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases 
set hlsearch " Highlight search results
set incsearch " Makes search act like search in modern browsers
set magic " For regular expressions turn magic on

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Re-map , for backward repeat find
nnoremap \ ,
vnoremap \ ,

" Enable wildmode
set wildignorecase
set wildmode=longest:full,full 
set wildmenu

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"-:---------------------------------------------------------------------------"
" Reading Saving, and History                                                 "
"-----------------------------------------------------------------------------"
" Set to auto read when a file is changed from the outside
" https://stackoverflow.com/questions/2490227/how-does-vims-autoread-work/20418591
set autoread
au FocusGained,BufEnter * :silent! noautocmd !

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowritebackup
set noswapfile

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.sql,*.yml,*.md :call CleanExtraSpaces()
endif

set history=500 " How many lines of history vim will remember

" Persistent undo (enable undo even after closing buffer)
" vim and nvim has incompatible undo structures currently
" see https://github.com/neovim/neovim/pull/13973#issuecomment-789544740
" This will hopefully change in the future
if has("nvim")
  set undodir=~/.vim/undodirs/nvim_undodir
else
  set undodir=~/.vim/undodirs/vim_undodir
endif
set undofile

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"-:---------------------------------------------------------------------------"
" Windows, Tabs, Buffers, and Navigation                                      "
"-----------------------------------------------------------------------------"
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Close current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Close all buffers
map <leader>ba :bufdo bd<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
" Changing to useopen only to get better behaviour out of Ack
try
  set switchbuf=useopen
  set stal=2
catch
endtry

" Quickly open a buffer for scribble
map <leader>e :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Remap VIM 0 to first non-blank character
" This caused such headache not understanding why online suggestions didn't work for me, but now I know I can go to actual start of line with |
map 0 ^

" Move a line of text 
nnoremap <leader>mj :m+1<CR>
nnoremap <leader>mk :m-2<CR>
vnoremap <leader>mj :m+1<CR>
vnoremap <leader>mk :m-2<CR>

" Override default netrw behaviour to include line numbers
let g:netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

" Do not include netrw browsing buffer in altfile
" This means that CTRL-^ will ignore it
let g:netrw_altfile = 1

"=:==========================================================================="
" filetypes                                                                   "
"============================================================================="

"-:---------------------------------------------------------------------------"
" dbt                                                                         "
"-----------------------------------------------------------------------------"
" Inspiration: https://github.com/jgillies/vim-dbt
" Inspiration: https://github.com/ivanovyordan/dbt.vim
" Inspiration: https://discourse.getdbt.com/t/syntax-highlighting-sql-linting/15/3
autocmd FileType dbt setlocal commentstring={#%s#}
au BufNewFile,BufRead *.sql set ft=dbt
autocmd FileType sql setlocal commentstring=/*%s*/


"=:==========================================================================="
" plugins                                                                     "
"============================================================================="

"-:---------------------------------------------------------------------------"
" vim-plug                                                                    "
"-----------------------------------------------------------------------------"
call plug#begin()
  Plug 'airblade/vim-gitgutter'
  Plug 'dense-analysis/ale'
  Plug 'glench/vim-jinja2-syntax'
  Plug 'honza/vim-snippets'
  Plug 'itchyny/lightline.vim'
  Plug 'ivanovyordan/dbt.vim'
  Plug 'jeetsukumaran/vim-indentwise'
  Plug 'jlanzarotta/bufexplorer'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-peekaboo'
  Plug 'kassio/neoterm'
  Plug 'kshenoy/vim-signature'
  Plug 'liuchengxu/vista.vim'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'maxbrunsfeld/vim-yankstack'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pbogut/fzf-mru.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-vinegar'
  Plug 'vimwiki/vimwiki'
call plug#end()


"-:---------------------------------------------------------------------------"
" FZF                                                                         "
"-----------------------------------------------------------------------------"
" Inspiration here: https://github.com/zenbro/dotfiles/blob/master/.nvimrc#L220-L264
" And here: https://github.com/euclio/vimrc/blob/master/plugins.vim#L174-L188

" For opening search results
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'window': 'new' }

" Basic FZF
nnoremap <c-f> :Files<CR>

" Find buffer
nnoremap <leader>fb :Buffers<CR>

" Find recent file using https://github.com/pbogut/fzf-mru.vim
nnoremap <leader>fh :FZFMru<CR>

" Find line in any buffer
nnoremap <leader>fl :Lines<CR>

" Find mark
nnoremap <leader>fm :Marks<CR>

" Find commit in current buffer
nnoremap <leader>fc :BCommits<CR>

" Search with ripgrep
" First make rg not include file names in search
" From here: https://github.com/junegunn/fzf/issues/1109
" And here: https://github.com/junegunn/fzf.vim/issues/346
" And here: https://github.com/junegunn/fzf.vim/issues/1051
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', 'ctrl-/'), <bang>0)
nnoremap <leader>g :Rg<CR>

" Search snippets (uses ultisnips)
nnoremap <leader>fs :Snippets<CR>

" Find tags
nnoremap <leader>ft :Tags<CR>

" Search commands
nnoremap <leader>f<space> :Commands<CR>


"-:---------------------------------------------------------------------------"
" FZFMRU                                                                      "
"-----------------------------------------------------------------------------"
let MRU_Max_Entries = 400
let g:fzf_mru_relative = 1
let g:fzf_mru_no_sort = 1


"-:---------------------------------------------------------------------------"
" bufExplorer                                                                 "
"-----------------------------------------------------------------------------"
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


"-:---------------------------------------------------------------------------"
" ALE                                                                         "
"-----------------------------------------------------------------------------"
" Used for linting and fixing (CoC is used for completion and LSP)
let g:ale_completion_enabled = 0
let g:ale_linters = {
      \ 'python': ['flake8']
      \} 
let g:ale_fixers = {
      \ 'python': ['black', 'autoflake']
      \}
let g:ale_fix_on_save = 1

" Navigate errors
nmap <silent> <leader>a <Plug>(ale_next_wrap)
nmap <silent> <leader>A <Plug>(ale_previous_wrap)


"-:---------------------------------------------------------------------------"
" YankStack                                                                   "
"-----------------------------------------------------------------------------"
let g:yankstack_yank_keys = ['y', 'd']

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


"-:---------------------------------------------------------------------------"
" Gitgutter                                                                   "
"-----------------------------------------------------------------------------"
let g:gitgutter_enabled = 1
let g:gitgutter_signs = 1
let g:gitgutter_map_keys = 0
nnoremap <silent> <leader>j :GitGutterToggle<cr>

" For lightline
function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
endfunction

highlight GitGutterAdd    guifg='green' ctermfg=2
highlight GitGutterChange guifg='yellow' ctermfg=3
highlight GitGutterDelete guifg='red' ctermfg=1


"-:---------------------------------------------------------------------------"
" vimwiki                                                                     "
"-----------------------------------------------------------------------------"
let g:vimwiki_list = [{'path': '~/Documents/notes/vim-wiki'}]


"-:---------------------------------------------------------------------------"
" peekaboo                                                                    "
"-----------------------------------------------------------------------------"
let g:peekaboo_window = "vertical topleft 50new"


"-:---------------------------------------------------------------------------"
" UltiSnips                                                                   "
"-----------------------------------------------------------------------------"
let g:UltiSnipsExpandTrigger="<c-j>"


"-:---------------------------------------------------------------------------"
" CoC                                                                        "
"-----------------------------------------------------------------------------"
" Used for autocompletion and LSP features (ALE is used for linting and fixing)
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap <C-g> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-g>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-g>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


"-:---------------------------------------------------------------------------"
" Lightline                                                                   "
"-----------------------------------------------------------------------------"
" Status line / tabline
" Inspiration here: https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc
" Lightline here: https://github.com/itchyny/lightline.vim

set noshowmode " Don't show -- INSERT -- below lightline
set laststatus=2

" Set up lightline options
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


"-:---------------------------------------------------------------------------"
" neoterm                                                                     "
"-----------------------------------------------------------------------------"
" BigQuery
nnoremap <leader>tq :exec('T cat % \| bq query --max_rows=100')
nnoremap <leader>td :exec('T cat % \| bq_dry')<CR>
nnoremap <leader>tf :exec('T cat % \| bq query --format=csv --max_rows=1000000 > output.csv')
nnoremap <leader>ts <Plug>(neoterm-repl-send)
nnoremap <leader>tbd :exec('T bq query "select * from `uswitch-ldn.region-europe-west2.INFORMATION_SCHEMA.SCHEMATA`" --max_rows=200')

" REPL
let g:neoterm_repl_python = 'python3 -m IPython' " this requires any virtual environment to already be activated
let g:neoterm_repl_enable_ipython_paste_magic=1
let g:neoterm_bracketed_paste=0

nnoremap <leader>sf :TREPLSendFile<CR>
nnoremap <leader>sl :TREPLSendLine<CR>
vnoremap <leader>sl :TREPLSendSelection<CR>


"-:---------------------------------------------------------------------------"
" vista                                                                     "
"-----------------------------------------------------------------------------"
let g:vista_sidebar_position = 'vertical topleft'
nnoremap <leader>v :Vista!!<CR>
nnoremap <leader>cv :Vista coc<CR>


"-:---------------------------------------------------------------------------"
" TBD - Need to decide if I want to keep these around                         "
"-----------------------------------------------------------------------------"
" Plug 'guns/vim-clojure-static'
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'guns/vim-sexp'
