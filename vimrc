set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'jelera/vim-javascript-syntax'
Plug 'gcmt/wildfire.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'keith/swift.vim'
Plug 'gfontenot/vim-xcode'
Plug 'scrooloose/syntastic'
Plug 'flowtype/vim-flow'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'vim-scripts/tComment'

call plug#end()

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ }
      \ }

set guifont=Inconsolata

syntax enable
filetype plugin indent on

set background=dark
colorscheme jellybeans

let mapleader = " "

"Case-insensitive searching.
set ignorecase

" But case-sensitive if expression contains a capital letter.
set smartcase

set backspace=2         " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set showcmd             " display incomplete commands
set showmode
set history=50
set incsearch           " do incremental searching
set ruler               " show the cursor position all the time
set laststatus=2        " Always display the status line
set autowrite

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
 
" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set relativenumber      " Use relative line numbers
set number
set numberwidth=5

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Use the system pasteboard
set clipboard=unnamed

" Quicker window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Gemfile set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufNewFile,BufRead Podfile,*.podspec set filetype=ruby
  autocmd BufNewFile,BufRead *liftoffrc set filetype=yaml
  autocmd BufNewFile,BufRead PULLREQ_EDITMSG set filetype=gitcommit

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Swift vim
let g:xcode_run_command = 'VtrSendCommandToRunner! {cmd}'
let g:xcode_xcpretty_testing_flags = '--test'

nnoremap <leader>b :XBuild<CR>
nnoremap <leader>u :XTest<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:flow#autoclose = 1
