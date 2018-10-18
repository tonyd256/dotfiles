set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'elixir-lang/vim-elixir'
Plug 'flowtype/vim-flow'
Plug 'gcmt/wildfire.vim'
Plug 'gfontenot/vim-xcode'
Plug 'itchyny/lightline.vim'
Plug 'pangloss/vim-javascript'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'keith/swift.vim'
Plug 'moll/vim-node'
Plug 'mxw/vim-jsx'
Plug 'nanotech/jellybeans.vim', { 'tag': 'v1.6' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/tComment'
" <Tab> indents or triggers autocomplete, smartly
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'raichoo/purescript-vim'
Plug 'jparise/vim-graphql'
Plug 'mustache/vim-mustache-handlebars'
Plug 'alx741/stylish-haskell'
Plug 'tomlion/vim-solidity'
Plug 'tpope/vim-liquid'
call plug#end()

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'inactive': {
      \   'left': [['filename'], ['modified']],
      \   'right': [['lineinfo'], ['percent']]
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
set scrolloff=1   " When scrolling, keep cursor in the middle
set shiftround    " When at 3 spaces and I hit >>, go to 4, not 5.

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

" Mnemonic: vgf = "vsplit gf"
nnoremap vgf :vsplit<CR>gf<CR>
" Mnemonic: sgf = "split gf"
nnoremap sgf :split<CR>gf<CR>

" Persistent undo
set undofile " Create FILE.un~ files for persistent undo
set undodir=~/.vim/undodir

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
  autocmd BufRead,BufNewFile Fastfile set filetype=ruby

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

" Fuzzy find files with fzf
nnoremap <leader>f :Files<CR>

" no ex mode
map Q <Nop>

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

let g:flow#autoclose = 1

map <Leader>n :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
