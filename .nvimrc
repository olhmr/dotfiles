"=:==========================================================================="
" basic                                                                       "
"=:==========================================================================="

"-:---------------------------------------------------------------------------"
" Startup optimisation                                                        "
"-----------------------------------------------------------------------------"
let g:loaded_python_provider=0
let g:python_host_skip_check=1
let g:python3_host_skip_check=1
let g:python3_host_prog='/usr/bin/python3'
let g:node_host_prog='/usr/local/bin/node'


"-:---------------------------------------------------------------------------"
" Initial                                                                     "
"-----------------------------------------------------------------------------"
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

" Enabling both number and relative number produces hybrid number
set number
set relativenumber 

" Toggle cursorline
:autocmd InsertEnter * set cul " Enable cursorline when entering insert mode
:autocmd InsertLeave * set nocul " Disable cursorline when existing insert mode

" Set how many lines to keep on the screen when scrolling
set scrolloff=7

set nocompatible " For vimwiki
set ruler " Always show position
set cmdheight=1 " Height of command bar
set hidden " Hide buffers when abandoned
set lazyredraw " Don't redraw while executing macros (good performance config)
set showmatch " Show matching brackets when text indicator is over them
set mat=2 " How many tenths of a second to blink when matching brackets
set foldcolumn=0 " Amount of extra margin to the left
set signcolumn=yes " Always show column to the left
set cc=80 " Add vertical at 80

" Basic tab setup
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


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

" Ignore whitespace in diff
set diffopt+=iwhite
set diffexpr=DiffW()
function DiffW()
  let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-w " " swapped vim's -b with -w
   endif
   silent execute "!diff -a --binary " . opt .
     \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction


"-:---------------------------------------------------------------------------"
" Miscellaneous                                                               "
"-----------------------------------------------------------------------------"
set updatetime=250 " Quicker response for things like gitgutter
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

" Enable wildmode
:set wildignorecase
:set wildmode=longest:full,full 

" Ignore compiled files in wildmode
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/env/*

" Configure backspace so it acts as it should act
" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=eol,start,indent 
set whichwrap+=<,>,h,l,[,]

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set encoding=utf8 " Set utf8 as standard encoding
set ffs=unix,dos,mac " Use Unix as the standard file type

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

" Pressing ,ss will toggle and untoggle spell checking
map <leader>sc :setlocal spell!<cr>

" Copy name of file
nmap ,cs :let @*=expand("%:t")<CR>
nmap ,cl :let @*=expand("%:p")<CR>

" Yank, paste, and delete using system clipboard
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>d "+d


"-:---------------------------------------------------------------------------"
" Reading Saving, and History                                                 "
"-----------------------------------------------------------------------------"
" Set to auto read when a file is changed from the outside
" https://stackoverflow.com/questions/2490227/how-does-vims-autoread-work/20418591
set autoread
au FocusGained,BufEnter * :silent! noautocmd !

" Fast saving
nmap <leader>w :w!<CR>

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

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Quickly open a buffer for scribble
" might remap this to <leader>e, need to check that that does
map <leader>q :e ~/buffer<cr>

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


"=:==========================================================================="
" filetypes                                                                   "
"============================================================================="

"-:---------------------------------------------------------------------------"
" Clojure                                                                     "
"-----------------------------------------------------------------------------"
" Special rules for AutoPair for clojure files - don't include single quotes (') or backticks (`)
au Filetype clojure let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"', '```':'```', '"""':'"""', "'''":"'''"}


"-:---------------------------------------------------------------------------"
" dbt                                                                         "
"-----------------------------------------------------------------------------"
" Inspiration: https://github.com/jgillies/vim-dbt
" Inspiration: https://github.com/ivanovyordan/dbt.vim
" Inspiration: https://discourse.getdbt.com/t/syntax-highlighting-sql-linting/15/3
au BufNewFile,BufRead *.sql set ft=dbt


"=:==========================================================================="
" plugins                                                                     "
"============================================================================="

"-:---------------------------------------------------------------------------"
" vim-plug                                                                    "
"-----------------------------------------------------------------------------"
call plug#begin()
  Plug 'mileszs/ack.vim'
  Plug 'dense-analysis/ale'
  Plug 'jlanzarotta/bufexplorer'
  Plug 'itchyny/lightline.vim'
  Plug 'yegappan/mru'
  Plug 'guns/vim-clojure-static'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  Plug 'guns/vim-sexp'
  Plug 'tpope/vim-fugitive'
  Plug 'mattn/vim-gist'
  Plug 'jeetsukumaran/vim-indentwise'
  Plug 'tpope/vim-surround'
  Plug 'maxbrunsfeld/vim-yankstack'
  Plug 'vimwiki/vimwiki'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/vim-peekaboo'
  Plug 'kassio/neoterm'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'pbogut/fzf-mru.vim'
  Plug 'kshenoy/vim-signature'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'lepture/vim-jinja'
  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-jedi'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'davidhalter/jedi-vim'
  Plug 'dstein64/vim-startuptime'
  Plug 'tpope/vim-vinegar'
call plug#end()

"-:---------------------------------------------------------------------------"
" bufExplorer                                                                 "
"-----------------------------------------------------------------------------"
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


"-:---------------------------------------------------------------------------"
" FZFMRU                                                                      "
"-----------------------------------------------------------------------------"
let MRU_Max_Entries = 400
let g:fzf_mru_relative = 1
let g:fzf_mru_no_sort = 1


"-:---------------------------------------------------------------------------"
" YankStack                                                                   "
"-----------------------------------------------------------------------------"
let g:yankstack_yank_keys = ['y', 'd']

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


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

" Find comit in current buffer
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


"-:---------------------------------------------------------------------------"
" snipMate                                                                    "
"-----------------------------------------------------------------------------"
" Support ctrl-j in addition to <tab>
ino <C-j> <C-r>=snipMate#TriggerSnippet()<cr>
snor <C-j> <esc>i<right><C-r>=snipMate#TriggerSnippet()<cr>


"-:---------------------------------------------------------------------------"
" ALE                                                                         "
"-----------------------------------------------------------------------------"
let g:ale_linters = {
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck']
\}

" Let's hold off on LSPs until there's a real need for them
let g:ale_disable_lsp = 1

" Navigate errors
nmap <silent> <leader>a <Plug>(ale_next_wrap)
nmap <silent> <leader>A <Plug>(ale_previous_wrap)


"-:---------------------------------------------------------------------------"
" Gitgutter                                                                   "
"-----------------------------------------------------------------------------"
let g:gitgutter_enabled=1
let g:gitgutter_signs=1
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
" Gist                                                                        "
"-----------------------------------------------------------------------------"
" Ensure gists are private by default
let g:gist_post_private = 1


"-:---------------------------------------------------------------------------"
" vimwiki                                                                     "
"-----------------------------------------------------------------------------"
let g:vimwiki_list = [{'path': '~/Documents/notes/vim-wiki'}]


"-:---------------------------------------------------------------------------"
" peekaboo                                                                    "
"-----------------------------------------------------------------------------"
" from https://github.com/junegunn/vim-peekaboo/issues/68#issuecomment-622601779
if has("nvim")
  function! CreateCenteredFloatingWindow()
      let width = float2nr(&columns * 0.6)
      let height = float2nr(&lines * 0.6)
      let top = ((&lines - height) / 2) - 1
      let left = (&columns - width) / 2
      let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
      let top = "╭" . repeat("─", width - 2) . "╮"
      let mid = "│" . repeat(" ", width - 2) . "│"
      let bot = "╰" . repeat("─", width - 2) . "╯"
      let lines = [top] + repeat([mid], height - 2) + [bot]
      let s:buf = nvim_create_buf(v:false, v:true)
      call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
      call nvim_open_win(s:buf, v:true, opts)
      set winhl=Normal:Floating
      let opts.row += 1
      let opts.height -= 2
      let opts.col += 2
      let opts.width -= 4
      call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
      au BufWipeout <buffer> exe 'bw '.s:buf
  endfunction
  let g:peekaboo_window="call CreateCenteredFloatingWindow()"
endif


"-:---------------------------------------------------------------------------"
" neoterm                                                                     "
"-----------------------------------------------------------------------------"
" :h terminal-input
tnoremap <Esc> <C-\><C-n>

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
" UltiSnips                                                                   "
"-----------------------------------------------------------------------------"
let g:UltiSnipsExpandTrigger="<c-j>"


"-:---------------------------------------------------------------------------"
" deoplete                                                                    "
"-----------------------------------------------------------------------------"
if exists('deoplete#enable')
  let g:deoplete#enable_at_startup = 0
  autocmd InsertEnter * call deoplete#enable()

  " <TAB>: completion - from https://github.com/Shougo/deoplete.nvim/issues/302
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
endif


"-:---------------------------------------------------------------------------"
" jedi-vim                                                                    "
"-----------------------------------------------------------------------------"
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another window
let g:jedi#use_splits_not_buffers = "right"

" remap go to assignment because I want fzf ripgrep in-file search on
" <leader>g
let g:jedi#goto_assignments_command = "<leader>h"


"-:---------------------------------------------------------------------------"
" lightline                                                                   "
"-----------------------------------------------------------------------------"
" Status line / tabline
" Inspiration here: https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc
" Lightline here: https://github.com/itchyny/lightline.vim
set noshowmode " Don't show -- INSERT -- below lightline

" Set up lightline options
let g:lightline = {
  \ 'colorscheme': 'srcery_drk',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
    \ 'left': [ [ 'mode', 'paste' ],
      \         [ 'absolutepath', 'readonly', 'fugitive', 'modified', 'gitgutter' ] ],
    \ 'right': [ [ 'percent', 'lineinfo' ],
      \          [ 'fileformat', 'fileencoding', 'filetype' ],
      \          [ 'linter_warnings', 'linter_errors', 'linter_ok' ] ]
  \ },
  \ 'component_function': {
    \ 'fugitive': 'FugitiveHead',
    \ 'gitgutter': 'LightLineGitGutter'
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
