scriptencoding utf-8
set encoding=utf-8

" Store the current system name so that we can conditionally set configs for
" different platforms
let s:uname = system("echo -n \"$(uname)\"")
let s:vim_dir = $HOME . "/.vim"

function! IsWindows()
  if s:uname =~ "mingw"
    return 1
  endif
  return 0
endfunction

let mapleader=","

set nocompatible
filetype off

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'mattn/webapi-vim' " Required by gist-vim
Plug 'mattn/gist-vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-dispatch'
Plug 'craigemery/vim-autotag'
Plug 'jeetsukumaran/vim-filesearch'
Plug 'embear/vim-localvimrc'

" DISABLED since it requires vim 7.3.598+ and I don't have that on my macbook
" Plug 'Valloric/YouCompleteMe'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'nelstrom/vim-qargs'

" Colors
Plug 'reedes/vim-colors-pencil'
Plug 'nanotech/jellybeans.vim'
Plug 'sickill/vim-monokai'
Plug 'elixir-lang/vim-elixir'
Plug 'chmllr/elrodeo-colorscheme'
Plug 'altercation/vim-colors-solarized'

" Clojure
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-clojure-highlight'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

call plug#end()

filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" allow unsaved background buffers and remember marks/undo for them
set hidden
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set dictionary+=/usr/share/dict/words
"set clipboard=unnamed " yank and paste with the system clipboard
set number
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79

if IsWindows()
  " Just assume we don't have a zsh shell
  set shell=bash
else
  set shell=zsh
endif

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Spell checking autocomplete
set complete+=kspell
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" use emacs-style tab completion when selecting files, etc
set wildmenu
set wildmode=longest,list,full
set wildignore+=*/tmp/*,*/log/*,*.so,*.swp,*.zip,*/rdoc/*
set colorcolumn=90
" Show trailing whitespace
set list listchars=tab:»·,trail:·
" Adding this since the esc remap on the 'i' key had a long delay when pressed
set timeoutlen=300 ttimeoutlen=0

" Allow undo when doing back into a closed file
set undolevels=1000
set undoreload=10000
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand(s:vim_dir . '/undo')
    " Create dirs
    if IsWindows()
      let mkdir = 'mkdir '
    else
      let mkdir = 'mkdir -p '
    endif
    :silent call system(mkdir . s:vim_dir)
    :silent call system(mkdir . undo_dir)
    let &undodir = undo_dir
    " Persist undo
    set undofile
endif

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal wrap
au BufNewFile,BufRead *.txt setlocal lbr

" Remove trailing whitespace on save all files.
au BufWritePre * :%s/\s\+$//e

" Fix vim's background colour erase - http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Notes and other helpers
map <leader>pn :sp ~/.personal-files/brain/writing/stack.txt<cr>
map <leader>sn :sp ~/.personal-files/documents/software-notes/clojure.md<cr>
map <leader>rn :sp ~/.work-files/dive-networks/files/notes/refactoring-notes.md<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run build script
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunBuildScript()
  let l:existing_buf = bufwinnr("__build_output_log__")
  let l:current_buf = bufnr("%")

  " Save current buffer in case there are unsaved changes
  silent! wall

  if l:existing_buf > 0
    silent! exe l:existing_buf . " wincmd w"
    "execute 'botright sb' l:existing_buf
  else
    botright sp __build_output_log__
    setlocal buftype=nofile
    resize 10
  endif

  " Clear the buffer
  normal! ggdG

  " Output compile log into buffer
  let l:output = system("./build.sh")
  call append(0, split(l:output, '\v\n'))
  go

  silent! exe l:existing_buf. " wincmd w"
endfunction

nnoremap <leader>b :call RunBuildScript()<cr>
nnoremap <leader>bb :bw!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lisp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rainbow parens ala rainbow_parentheses.vim
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" properly indent schemes (scheme, racket, etc)
autocmd bufread,bufnewfile *.lisp,*.scm,*.rkt setlocal equalprg=scmindent.rkt

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:default_bg = 'dark'
let s:dark_theme = 'pencil'
let s:light_theme = 'pencil'
let g:airline_theme = 'pencil'

if s:default_bg =~ 'light'
  " The order that these are set matters for some themes
  exe 'colorscheme ' . s:light_theme
  set background=light
else
  exe 'colorscheme ' . s:dark_theme
  set background=dark
endif

" Switch between light and dark
map <leader>l :call ChangeBgTheme('dark')<cr>
map <leader>ll :call ChangeBgTheme('light')<cr>

function! ChangeBgTheme(bg)
  if a:bg =~ 'light'
    let s:theme = s:light_theme
  else
    let s:theme = s:dark_theme
  endif

  exe 'colorscheme ' . s:theme
  exe 'set background=' . a:bg
  " Have to run this twice to get the plugin to set the colors
  exec ":RainbowParenthesesToggle"
  exec ":RainbowParenthesesToggle"
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Spell check
  autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HIGHLIGHT TODO, NOTE, FIXME, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc_bugs
    au!
    au Syntax * syn match MyBugs /\v<(FIXME|BUG|DEPRECATED|OPTIMIZE):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyBugs Todo

augroup vimrc_notes
    au!
    au Syntax * syn match MyNotes /\v<(IDEA|NOTE|QUESTION|WARNING|IMPORTANT):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyNotes WildMenu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gb :Gblame<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCHING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Not sure if I still need this
map <leader>gs :let @/ = ""<CR>

" Replace the selected text in all files within the repo
function! GlobalReplaceIt(confirm_replacement)
  if exists(':Ggrep')
   " let term = @/
   " if empty(term)
      call inputsave()
      let l:term = input('Enter search term: ')
      call inputrestore()
   " else
   "   echo '\nReplacing '.term
   " endif
    call inputsave()
    let l:replacement = input('Enter replacement: ')
    call inputrestore()
    if a:confirm_replacement
      let l:confirm_opt = 'c'
    else
      let l:confirm_opt = 'e'
    endif
    execute 'Ggrep '.l:term
    execute 'Qargs | argdo %s/'.l:term.'/'.l:replacement.'/g'.l:confirm_opt.' | update'
  else
    echo "Unable to search since you're not in a git repo"
  endif
endfunction
map <leader>gg :call GlobalReplaceIt(0)<cr>
map <leader>gr :call GlobalReplaceIt(1)<cr>

function! Search()
  let l:term = input('Grep search term: ')
  if l:term != ''
    if IsWindows()
      exec 'Fsgrep "' . l:term . '"'
    else
      exec 'Ag "' . l:term . '"'
    endif
  endif
endfunction
map <leader>s :call Search()<cr>

command! -nargs=+ MyGrep execute 'silent grep! <args>' | copen 33

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" insert an end tag with <c-e>
imap <c-e> end

" insert a clojure lambda <c-l>
imap <c-l> (fn [x]<space>

" Mapping ESC in insert mode and command mode to double i
"imap ii <C-[>
"cmap ii <C-[>

" suspend process
nmap <leader>z <c-z>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :vsp $MYVIMRC<cr>
nmap <silent> <leader>rv :so $MYVIMRC<cr>

" remap saving and quiting
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
nmap <leader>qq :q!<cr>
nmap <leader>x :x<cr>
:ca Wa wa
:ca WA wa
:ca WQ wq
:ca Wq wq
:ca W w
:ca Q q

command! Q q " Bind :Q to :q
command! Qall qall
" Disable Ex mode
map Q <Nop>

if exists(':terminal')
  " Terminal mapping
  map <leader>t :terminal<cr>
  tnoremap <leader>e <C-\><C-n>
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
endif

" Map ctrl-movement keys to window switching
map <c-k> <c-w><Up>
map <c-j> <c-w><Down>
map <c-l> <c-w><Right>
map <c-h> <c-w><Left>

" Make it easier to jump around the command line. The default behaviour is
" using the arrow keys with or without shift
:cnoremap <C-J> <S-Left>
:cnoremap <C-K> <S-Right>

" Window splitting - couldn't figure out how to remap <c-w>v & <c-w>n to <c-m>
" & <c-n>
map <leader>m :vsplit<cr>
map <leader>mm :split<cr>

" Delete a word forward and backward
map <leader>a daw
map <leader>d ciw

" Map paste and nonumber
map <leader>p :set paste! paste?<cr>
map <leader>o :set number! number?<cr>

" Spell checking
map <leader>j :exec &spell==&spell? "se spell! spelllang=en_us" : "se spell!"<cr>
map <leader>= z=

" Clear the search buffer (highlighting) when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>

" Replace currently selected text with default register without yanking it
vnoremap p "_dP


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ABBREVIATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:ab teh the
:ab taht that
:ab kewyord keyword
:ab indentity identity
:ab indetity identity


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let l:col = col('.') - 1
    if !l:col || getline('.')[l:col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let l:old_name = expand('%')
    let l:new_name = input('New file name: ', expand('%'), 'file')
    if l:new_name != '' && l:new_name != l:old_name
        exec ':saveas ' . l:new_name
        exec ':silent !rm ' . l:old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>pl :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MARKDOWN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Marked.app to preview Markdown files...
nnoremap <leader>pp :silent !open -a Marked.app '%:p'<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SELECTA -- find files with fuzzy-search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  if IsWindows()
    let l:term = input('File name: ')
    exec 'Fsfind "' . l:term . '"'
  else
    try
      let l:selection = system(a:choice_command . " | selecta " . a:selecta_args)
    catch /Vim:Interrupt/
      " Swallow the ^C so that the redraw below happens; otherwise there will be
      " leftovers from selecta on the screen
      redraw!
      return
    endtry
    redraw!
    exec a:vim_command . " " . l:selection
  endif
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find * -type f ! -path 'resources/public/js/*' ! -path 'resources/.sass-cache/*' ! -path 'target/*'", "", ":e")<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIST VIM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-CLOJURE-STATIC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default
 let g:clojure_fuzzy_indent = 1
 let g:clojure_align_multiline_strings = 1
 let g:clojure_fuzzy_indent_patterns = ['^match', '^with', '^def', '^let']
 let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILESEARCH
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 let g:filesearch_viewport_split_policy = "B"
 let g:filesearch_split_size = 10
 let g:filesearch_autodismiss_on_select = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOCAL VIMRC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-TAGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags;$HOME
