scriptencoding utf-8
" Based on Josh's vim configuration (http://github.com/knewter/dotfiles)

" Table of Contents
" 1) Basics #basics
"   1.1) Tabs #tabs
"   1.2) Format Options #format-options
"   1.3) Leader #leader
"   1.4) Omni #omni
"   1.5) UI Basics #ui-basics
" 2) Plugins #plugins
"   2.1) Filetypes #filetypes
"   2.2) Utilities #utilities
"   2.3) UI Plugins #ui-plugins
"   2.4) Code Navigation #code-navigation
" 3) UI Tweaks #ui-tweaks
"   3.1) Theme #theme
" 4) Navigation #navigation

"""""""""""""" Basics #basics
""" Tabs #tabs
" - Two spaces wide
set tabstop=2
set softtabstop=2
" - Expand them all
set expandtab
" - Indent by 2 spaces by default
set shiftwidth=2
" 2 lines of context below and above all the time
set scrolloff=2
" Use system clipboard
set clipboard=unnamed

""" Format Options #format-options
set formatoptions=tcrq
"set textwidth=80
" Display extra whitespace
set list listchars=tab:»·,trail:·

""" Leader #leader
" Use space for leader
let g:mapleader=' '

""" omni #omni
" enable omni syntax completion
set omnifunc=syntaxcomplete#Complete

""" UI Basics #ui-basics
" turn on mouse
set mouse=a

" NOTE: I stopped highlighting cursor position because it makes redrawing
" super slow.
" set cursorline
" set cursorcolumn

" Highlight search results
set hlsearch
" Incremental search, search as you type
set incsearch
" Ignore case when searching
set ignorecase smartcase
" Ignore case when searching lowercase
set smartcase

" Set the title of the iterm tab
set title

" Line numbering
set number
set numberwidth=5

""" Undo #undo
" undofile - This allows you to use undos after exiting and restarting
" :help undo-persistence
set undofile

"""""""""""""" End Basics

"""""""""""""" Plugins #plugins
call plug#begin('~/.config/nvim/plugged')

""" Filetypes #filetypes
" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = ['elm']

" Elixir
Plug 'slashmili/alchemist.vim'

" Phoenix
Plug 'c-brenn/phoenix.vim'
Plug 'tpope/vim-projectionist' " required for some navigation features

" Elm
Plug 'ElmCast/elm-vim'
  let g:elm_format_autosave = 1

""" Utilities #utilities
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif
  " use tab for completion
  inoremap <expr><Tab> pumvisible() ? "\<c-n>" : "\<Tab>"
  inoremap <expr><S-Tab> pumvisible() ? "\<c-p>" : "\<S-Tab>"

" Add comment textobjects (I really want to reformat comments without affecting
" the next line of code)
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment'
  " Example: Reformat a comment with `gqac` (ac is "a comment")

" EditorConfig support
Plug 'editorconfig/editorconfig-vim'

" Jump between quicklist, location (syntastic, etc) items with ease, among other things
Plug 'tpope/vim-unimpaired'

" Line commenting
Plug 'tomtom/tcomment_vim'
  " By default, `gc` will toggle comments

Plug 'janko-m/vim-test'                " Run tests with varying granularity
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>
  " run tests in neovim strategy
  let g:test#strategy = 'neovim'
  " I use spinach, not cucumber!
  let g:test#ruby#cucumber#executable = 'spinach'

" git support from dat tpope
Plug 'tpope/vim-fugitive'

" github support from dat tpope
Plug 'tpope/vim-rhubarb'

" vim interface to web apis.  Required for gist-vim
Plug 'mattn/webapi-vim'

" create gists trivially from buffer, selection, etc.
Plug 'mattn/gist-vim'
  let g:gist_open_browser_after_post = 1
  let g:gist_detect_filetype = 2
  let g:gist_post_private = 1
  if has('macunix')
    let g:gist_clip_command = 'pbcopy'
  endif

" visualize your undo tree
Plug 'sjl/gundo.vim'
  nnoremap <F5> :GundoToggle<CR>

""" UI Plugins #ui-plugins
Plug 'morhetz/gruvbox'
Plug 'sickill/vim-monokai'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme= 'luna'
  let g:bufferline_echo = 0
  let g:airline_powerline_fonts=1
  let g:airline_enable_branch=1
  let g:airline_enable_syntastic=1
  let g:airline_branch_prefix = '⎇ '
  let g:airline_paste_symbol = '∥'
  let g:airline#extensions#tabline#enabled = 0

""" Code Navigation #code-navigation
" fzf fuzzy finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'window': 'enew' }
  let $FZF_DEFAULT_COMMAND = 'ag -g ""'
  nnoremap <silent> <C-P> :FZF<cr>
  nnoremap <silent> <leader>a :Ag<cr>
  augroup localfzf
    autocmd!
    autocmd FileType fzf :tnoremap <buffer> <C-J> <C-J>
    autocmd FileType fzf :tnoremap <buffer> <C-K> <C-K>
  augroup END

" Open files where you last left them
Plug 'dietsche/vim-lastplace'

" Execute code checks, find mistakes, in the background
Plug 'neomake/neomake'
  " Run Neomake when I save any buffer
  augroup localneomake
    autocmd! BufWritePost * Neomake
  augroup END

  " Configure a nice credo setup, courtesy https://github.com/neomake/neomake/pull/300
  let g:neomake_elixir_enabled_makers = ['mix', 'mycredo']
  function! NeomakeCredoErrorType(entry)
    if a:entry.type ==# 'F'      " Refactoring opportunities
      let l:type = 'W'
    elseif a:entry.type ==# 'D'  " Software design suggestions
      let l:type = 'I'
    elseif a:entry.type ==# 'W'  " Warnings
      let l:type = 'W'
    elseif a:entry.type ==# 'R'  " Readability suggestions
      let l:type = 'I'
    elseif a:entry.type ==# 'C'  " Convention violation
      let l:type = 'W'
    else
      let l:type = 'M'           " Everything else is a message
    endif
    let a:entry.type = l:type
  endfunction

  let g:neomake_elixir_mycredo_maker = {
        \ 'exe': 'mix',
        \ 'args': ['credo', 'list', '%:p', '--format=oneline'],
        \ 'errorformat': '[%t] %. %f:%l:%c %m,[%t] %. %f:%l %m',
        \ 'postprocess': function('NeomakeCredoErrorType')
        \ }

" Easily manage tags files
Plug 'ludovicchabant/vim-gutentags'
  let g:gutentags_cache_dir = '~/.tags_cache'

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'

call plug#end()
"""""""""""""" End Plugins

"""""""""""""" UI Tweaks #ui-tweaks
""" Theme #theme
if (empty($TMUX))
  if (has('termguicolors'))
    set termguicolors
  endif
endif
set background=dark
syntax enable
colorscheme gruvbox
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0


""" Keyboard
" Remove highlights
" Clear the search buffer when hitting return
" nnoremap <silent> <cr> :nohlsearch<cr>

" NO ARROW KEYS COME ON
map <Left>  :echo "use h"<cr>
map <Right> :echo "use l"<cr>
map <Up>    :echo "use k"<cr>
map <Down>  :echo "use j"<cr>

" Custom split opening / closing behaviour
map <C-N> :vsp<CR><C-P>
map <C-C> :q<CR>
set splitright
set splitbelow
" Custom tab opening behaviour
map <leader>n :tabnew .<CR><C-P>

" reselect pasted content:
noremap gV `[v`]

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Split line (sister to [J]oin lines above)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Open the alternate file
map ,, <C-^>

" Makes foo-bar considered one word
set iskeyword+=-

""" Auto Commands ====================== #auto-cmd
""""" Filetypes ========================
augroup erlang
  autocmd!
  autocmd BufNewFile,BufRead *.erl setlocal tabstop=4
  autocmd BufNewFile,BufRead *.erl setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.erl setlocal softtabstop=4
  autocmd BufNewFile,BufRead relx.config setlocal filetype=erlang
augroup END

augroup elm
  autocmd!
  autocmd BufNewFile,BufRead *.elm setlocal tabstop=4
  autocmd BufNewFile,BufRead *.elm setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.elm setlocal softtabstop=4
augroup END

augroup dotenv
  autocmd!
  autocmd BufNewFile,BufRead *.envrc setlocal filetype=sh
augroup END

augroup es6
  autocmd!
  autocmd BufNewFile,BufRead *.es6 setlocal filetype=javascript
  autocmd BufNewFile,BufRead *.es6.erb setlocal filetype=javascript
augroup END

augroup markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=80
  autocmd FileType markdown setlocal formatoptions=tcrq
augroup END

augroup viml
  autocmd!
  autocmd FileType vim setlocal textwidth=80
  autocmd FileType vim setlocal formatoptions=tcrq
augroup END
""""" End Filetypes ====================

""""" Normalization ====================
" Delete trailing white space on save
func! DeleteTrailingWS()
  exe 'normal mz'
  %s/\s\+$//ge
  exe 'normal `z'
endfunc

augroup whitespace
  autocmd BufWrite * silent call DeleteTrailingWS()
augroup END
""""" End Normalization ================
""" End Auto Commands ==================

""" Navigation ====================== #navigation
" Navigate terminal with C-h,j,k,l
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Navigate splits with C-h,j,k,l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <BS> <C-w>h
" Have to add this because hyperterm sends backspace for C-h
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Navigate tabs with leader+h,l
" It's hard to hit space and h/l simultaneously so increase the timeout for
" space
nnoremap <leader>[ :tabprev<cr>
nnoremap <leader>] :tabnext<cr>

" NERDTree
map <leader>k :NERDTreeToggle<cr>
map <leader>f :NERDTreeFind<cr>
let NERDTreeShowHidden=1
""" End Navigation ==================
