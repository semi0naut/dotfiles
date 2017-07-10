"Remove Menubar and Toolbar from gvim
"set guioptions -=m
"set guioptions -=T

scriptencoding utf-8
set encoding=utf-8 fileencoding=utf-8 fileencodings=ucs-bom,utf8,prc

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

" /////////////////////////////////////////////////////////////////////
" Misc
" /////////////////////////////////////////////////////////////////////

Plug 'mattn/webapi-vim' " Required by gist-vim
Plug 'mattn/gist-vim'
Plug 'bling/vim-airline'
Plug 'vim-scripts/VimCalc' " Requires a vim compiled with Python support
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'embear/vim-localvimrc'
Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-classpath' " TODO: still need this?

" Automatically discover and 'properly' update ctags files on save
Plug 'craigemery/vim-autotag'

Plug 'jeetsukumaran/vim-filesearch'
Plug 'rking/ag.vim'
Plug 'nelstrom/vim-qargs' " For search and replace
Plug 'tommcdo/vim-lion' " For text alignment, use gl= and gL=

" Easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/tpope-vim-abolish'

" Maintain a manually-defined jump stack. Set with zp and pop with zP
Plug 'tommcdo/vim-kangaroo'

" Async commands + build error highlighting
Plug 'skywind3000/asyncrun.vim'
Plug 'mh21/errormarker.vim'

" Plug 'shougo/unite.vim' # Create user interfaces. Not currently needed.
" DISABLED since it requires vim 7.3.598+ and I don't have that on my macbook
" Plug 'Valloric/YouCompleteMe'

" /////////////////////////////////////////////////////////////////////
" Colors
" /////////////////////////////////////////////////////////////////////

Plug 'godlygeek/csapprox' " Try to make gvim themes look decent in Windows

Plug 'eapache/rainbow_parentheses.vim'

" WARNING: Has a lot of themes, but they break the other themes listed below
"Plug 'flazz/vim-colorschemes'
Plug 'elixir-lang/vim-elixir'
Plug 'vim-airline/vim-airline-themes'

" Light Themes
Plug 'raggi/vim-color-raggi' " No Win support, unless using gvim
Plug 'LanFly/vim-colors'     " No Win support, unless using gvim

" Dark Themes
Plug 'rhysd/vim-color-spring-night' " No Win support, unless using gvim
Plug 'nanotech/jellybeans.vim'
Plug 'zcodes/vim-colors-basic'

" Hybrid Themes

" Seabird themes
" High contrast: seagull  (light),  petrel      (dark)
" Low contrast:  greygull (light),  stormpetrel (dark)
Plug 'nightsense/seabird' " No Win support, unless using gvim
Plug 'sickill/vim-monokai'
Plug 'chmllr/elrodeo-vim-colorscheme' " A little dark on Windows, term
Plug 'reedes/vim-colors-pencil' " High-contrast


" /////////////////////////////////////////////////////////////////////
" Clojure
" /////////////////////////////////////////////////////////////////////
Plug 'guns/vim-clojure-highlight'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Rust
Plug 'rust-lang/rust.vim'

" Ruby
Plug 'vim-ruby/vim-ruby'

" Go
Plug 'fatih/vim-go'

" QML
Plug 'peterhoeg/vim-qml'

" Markdown
Plug 'tpope/vim-markdown'

" C++
Plug 'bfrg/vim-cpp-enhanced-highlight'

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
set nonumber
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cmdheight=2
set switchbuf=useopen,split
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
" Build Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AsyncRun status line
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" Display error highlighting in source after running GCC with AsyncRun
" NOTE: error results can be cleared with <leader>cr or by hiding the build
" result window.
let g:asyncrun_auto = "make"
let errormarker_errortext = "E"
let errormarker_warningtext = "W"

" Thanks to https://forums.handmadehero.org/index.php/forum?view=topic&catid=4&id=704#3982
" for the error message formats
" Microsoft MSBuild errors
set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
" Microsoft compiler: cl.exe
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
" Microsoft HLSL compiler: fxc.exe
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m

let g:build_window_size = 12 " in rows

function! HideBuildResultsAndClearErrors()
  RemoveErrorMarkers
  call asyncrun#quickfix_toggle(g:build_window_size, 0)
endfunction

function! ToggleBuildResults()
  call asyncrun#quickfix_toggle(g:build_window_size)
endfunction

function! StopRunTask()
  AsyncStop
  call asyncrun#quickfix_toggle(g:build_window_size, 0)
endfunction

function! ExecuteRunScript()
  exec "AsyncRun! -post=call\\ StopRunTask() ./run"
endfunction

" Show results window the moment the async job starts
augroup vimrc
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(g:build_window_size, 1)
augroup END

" Toggle build results
noremap <F9> :call ToggleBuildResults()<cr>
nnoremap <leader>bb :call ToggleBuildResults()<cr>

" Hide build results and clear errors
noremap <F10> :call HideBuildResultsAndClearErrors()<cr>

" Execute build script
nnoremap <leader>b :AsyncRun! -save=2 ./build*<cr>
nnoremap <F8> :AsyncRun! -save=2 ./build*<cr>

" Execute run script
nnoremap <leader>br :call ExecuteRunScript()<cr>
nnoremap <leader>bs :AsyncStop<cr>

"Go to next build error
nnoremap <F7> :cn<CR>
nnoremap <C-n> :cn<CR>

"Go to previous build error
nnoremap <F6> :cp<CR>
nnoremap <C-p> :cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lisp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rainbow parens ala rainbow_parentheses.vim
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Schemes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" properly indent schemes (scheme, racket, etc)
autocmd bufread,bufnewfile *.lisp,*.scm,*.rkt setlocal equalprg=scmindent.rkt

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:default_bg = 'dark'
let s:dark_theme = 'campo-dark'
let s:light_theme = 'campo-light'

" Switch between light and dark
map <leader>l :call ChangeBgTheme('light', 0)<cr>
map <leader>ll :call ChangeBgTheme('dark', 0)<cr>

function! ChangeBgTheme(bg, onlySetTheme)
  if a:bg =~ 'light'
    let s:theme = s:light_theme
    exe 'colorscheme ' . s:theme
    set background=light
  else
    let s:theme = s:dark_theme
    " We have to set the theme twice in order to get its correct dark-theme colors.
    " Weird stuff.
    exe 'colorscheme ' . s:theme
    set background=dark
    exe 'colorscheme ' . s:theme
  endif

  if !a:onlySetTheme
    exec ':AirlineTheme ' . a:bg
    " Have to run this twice to get the plugin to set the colors
    exec ':RainbowParenthesesToggle'
    exec ':RainbowParenthesesToggle'
  endif
endfunction

if s:default_bg =~ 'light'
  call ChangeBgTheme('light', 1)
else
  call ChangeBgTheme('dark', 1)
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  autocmd FileType gitcommit setlocal colorcolumn=72

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  autocmd FileType ruby,haml,eruby,yaml,html,javascript,rust,go set ai sw=2 sts=2 et
  autocmd FileType python,qml set sw=4 sts=4 et

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HIGHLIGHT TODO, NOTE, FIXME, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NOTE: These depend on custom color names (Bugs, Notes and Notices) defined
" in the campo color themes. Since most themes won't define these, you can
" use WildMenu as substitution.
"
" FIXME: the custom Bugs, Notes and Notices highlighting for campo-light isn't
" working...

augroup vimrc_bugs
    au!
    au Syntax * syn match MyBugs /\v<(FIXME|BUG|DEPRECATED):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyBugs Bugs

augroup vimrc_notes
    au!
    au Syntax * syn match MyNotes /\v<(IDEA|NOTE|QUESTION|WARNING|IMPORTANT):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyNotes Notes

augroup vimrc_notices
    au!
    au Syntax * syn match MyNotices /\v<(WARNING|IMPORTANT):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyNotices Notices

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
      " is pt faster than ag? I forget now and didn't document it
      exec 'pt "' . l:term . '"'
      "exec 'Ag "' . l:term . '"'
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
" NOTE: you can add a new word to the dict with `zg`

" Clear the search buffer (highlighting) when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>

" Replace currently selected text with default register without yanking it
vnoremap p "_dP


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEXT ALIGNMENT PLUGIN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let b:lion_squeeze_spaces = 1


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
" RUST.VIM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:rustfmt_autosave = 1 " auto run rust formatter when saving

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: there is a status line config in the status line section
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Customize Rust
" https://github.com/rust-lang/rust.vim/issues/130
" Can remove once this Syntastic PR is merged https://github.com/rust-lang/rust.vim/pull/132
"let g:syntastic_rust_rustc_exe = 'cargo check'
"let g:syntastic_rust_rustc_fname = ''
"let g:syntastic_rust_checkers = ['rustc']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-TAGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags;$HOME
