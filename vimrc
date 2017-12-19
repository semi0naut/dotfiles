"Remove Menubar and Toolbar from gvim
"set guioptions -=m
"set guioptions -=T

scriptencoding utf-8
set encoding=utf-8 fileencoding=utf-8 fileencodings=ucs-bom,utf8,prc
set nocompatible
filetype off

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

"################################################################
"################################################################
"################################################################
" 0. GLOBALS
"################################################################
"################################################################
"################################################################

let s:max_row_length = 100
let s:default_bg = 'dark'
let s:rainbow_theme = s:default_bg


"-----------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
" 1. PLUGINS
"################################################################
"################################################################
"################################################################


call plug#begin('~/.vim/plugged')

"////////////////////////////////////////////////////////////////
" MISC
"////////////////////////////////////////////////////////////////

Plug 'mattn/webapi-vim' " Required by gist-vim
Plug 'mattn/gist-vim'
Plug 'bling/vim-airline'
Plug 'vim-scripts/VimCalc' " Requires a vim compiled with Python support
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'embear/vim-localvimrc'
Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-classpath' " TODO: still need this?
Plug 'junegunn/goyo.vim' " Distraction-free mode with centered buffer
Plug 'fedorenchik/VimCalc3' " A calculator inside vim

if IsWindows()
  Plug 'suxpert/vimcaps' " Disable capslock (useful if the OS isn't configured to do so)
endif

Plug 'itchyny/vim-cursorword' " Underlines the word under the cursor
Plug 'itchyny/thumbnail.vim' " View open buffers in a Chrome-inspired thumbnail layout
" Google Calendar - :Calendar, :Calendar <year> <m#> <d#>, :Calendar -view=year (-split=veritcal -width=<n>)
" :Calendar -view=day, :Calendar -first_day=monday
Plug 'itchyny/calendar.vim'
Plug 'itchyny/screensaver.vim' " A screensaver view - open with :ScreenSaver
" (MAYBE) Plug 'itchyny/vim-winfix'

if !IsWindows()
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'itchyny/dictionary.vim' " A way to query dictionary.com with :Dictionary
endif

" Automatically discover and 'properly' update ctags files on save
Plug 'craigemery/vim-autotag'
Plug 'majutsushi/tagbar'

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


"////////////////////////////////////////////////////////////////
" COLORS
"////////////////////////////////////////////////////////////////

Plug 'godlygeek/csapprox' " Try to make gvim themes look decent in Windows

Plug 'sir-pinecone/rainbow'

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
Plug 'sickill/vim-monokai'
Plug 'chmllr/elrodeo-vim-colorscheme' " A little dark on Windows, term
Plug 'reedes/vim-colors-pencil' " High-contrast
" Seabird themes
  " High contrast: seagull  (light),  petrel      (dark)
  " Low contrast:  greygull (light),  stormpetrel (dark)
Plug 'nightsense/seabird' " No Win support, unless using gvim


"////////////////////////////////////////////////////////////////
" CLOJURE
"////////////////////////////////////////////////////////////////
Plug 'guns/vim-clojure-highlight'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }


"////////////////////////////////////////////////////////////////
" OTHER LANGUAGES
"////////////////////////////////////////////////////////////////

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

" Haxe
Plug 'jdonaldson/vaxe'

call plug#end()

filetype plugin indent on


"-----------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
" 2. BASE CONFIG
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" allow unsaved background buffers and remember marks/undo for them
set hidden
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showcmd " display incomplete commands
set showmatch
set incsearch " Highlight matches as you type
set hlsearch " Highlight matches
set dictionary+=/usr/share/dict/words
"set clipboard=unnamed " yank and paste with the system clipboard
set nonumber
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set visualbell " No bell sounds
set ttyfast
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
set directory=$HOME/tmp " For swap files
set backupdir=$HOME/tmp
:au BufWritePre * let &bex = '.' . strftime("%Y-%m-%d-%T") . '.bak'

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
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
let &colorcolumn=s:max_row_length
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup campoCmds
  " Clear all autocmds in the group
  autocmd!

  " Automatically wrap at N characters
  autocmd FileType gitcommit setlocal colorcolumn=72
  autocmd BufRead,BufNewFile *.{md,txt,plan} execute "setlocal textwidth=" .s:max_row_length

  " Spell checking
  autocmd FileType gitcommit,markdown,text setlocal spell

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  autocmd FileType ruby,haml,eruby,yaml,html,javascript,rust,go set ai sw=2 sts=2 et
  autocmd FileType python,qml set sw=4 sts=4 et

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Properly indent schemes (scheme, racket, etc)
  autocmd bufread,bufnewfile *.{lisp,scm,rkt} setlocal equalprg=scmindent.rkt

  " Auto reload VIM when settings changed
  autocmd BufWritePost .vimrc so $MYVIMRC
  autocmd BufWritePost *.vim so $MYVIMRC
  autocmd BufWritePost vimrc.symlink so $MYVIMRC

  " Remove trailing whitespace on save all files.
  function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
  endfun
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

  "////////////////////////////////////////////////////////////////
  " FILE TEMPLATES
  "////////////////////////////////////////////////////////////////

  " Shell script template
  autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
  autocmd BufNewFile *.plan 0r ~/.vim/templates/skeleton.plan

  " C/C++ template
  autocmd bufnewfile *.{c,cc,cpp,h,hpp} 0r ~/.vim/templates/c_header_notice
  autocmd bufnewfile *.{c,cc,cpp,h,hpp} exe "2," . 6 . "g/File:.*/s//File: " .expand("%")
  autocmd bufnewfile *.{c,cc,cpp,h,hpp} exe "2," . 6 . "g/Creation Date:.*/s//Creation Date: " .strftime("%Y-%m-%d")
  autocmd bufnewfile *.{c,cc,cpp,h,hpp} exe "2," . 6 . "g/$year/s//" .strftime("%Y")
  function! s:InsertHeaderGates()
    let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    execute "normal! ggO#ifndef " . gatename
    normal! Go
    normal! Go
    execute "normal! Go#define " . gatename . " "
    execute "normal! o#endif"
    normal! kkk
  endfunction
  autocmd bufnewfile *.{h,hpp} call <SID>InsertHeaderGates()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping ESC in insert mode and command mode to double i
"imap ii <C-[>
"cmap ii <C-[>

" suspend process
nmap <leader>z <c-z>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :vsp $MYVIMRC<cr>
nmap <silent> <leader>rv :so $MYVIMRC<cr>

" Easy way to open a file in the directory of the current file
:cmap %/ %:p:h/

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

" lowercase the e (have a habit of making it uppercase)
:ca E e

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

" Use Marked.app to preview Markdown files...
nnoremap <leader>pp :silent !open -a Marked.app '%:p'<cr>

" Switch between C++ source and header files
map <leader>v :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
map <leader>vv :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

"////////////////////////////////////////////////////////////////
" QUICKLY OPEN C++ SOURCE OR HEADER FILE
"////////////////////////////////////////////////////////////////

function! s:CompleteFilenameWithoutExtension(ArgLead, CmdLine, CursorPos)
  " Returns a matching filename without the period that separates the name
  " from the extension.
  let l:file = substitute(glob(a:ArgLead.'*', 0, 0), "[\.].*", "", "*")
  return l:file
endfunction

" Custom command to open cpp and h files without typing an extension
command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppSource execute ':e <args>.cpp'
:ca c OpenCppSource
:ca C OpenCppSource

command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppHeader execute ':e <args>.h'
:ca h OpenCppHeader
:ca H OpenCppHeader

command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppSourceAndHeader execute ':vsp | :e <args>.h | :sp <args>.cpp'
:ca b OpenCppSourceAndHeader
:ca B OpenCppSourceAndHeader

"////////////////////////////////////////////////////////////////
" MULTIPURPOSE TAB KEY
"////////////////////////////////////////////////////////////////
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


"-----------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
" 3. PLUGIN CONFIGS
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOCAL VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAGBAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F12> :TagbarToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CALENDAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:calendar_google_calendar = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTASTIC
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gb :Gblame<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIST VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-CLOJURE-STATIC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default
let g:clojure_fuzzy_indent = 1
let g:clojure_align_multiline_strings = 1
let g:clojure_fuzzy_indent_patterns = ['^match', '^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUST.VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:rustfmt_autosave = 1 " auto run rust formatter when saving


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RAINBOW
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1 " Always on
"let g:rainbow_conf = {
"\}

let s:light_rainbow = ['red', 'green', 'magenta', 'cyan', 'yellow', 'white', 'gray', 'blue']
let s:dark_rainbow = ['darkblue', 'red', 'black', 'darkgreen', 'darkyellow', 'darkred', 'darkgray']

function! UpdateRainbowConf()
  let g:rainbow_conf = {
        \   'ctermfgs': (s:rainbow_theme == "light"? s:dark_rainbow : s:light_rainbow)
   \}
"\   'separately': {
"\       '*': 0, " Disable all
"\       'c++': {} " Only enable c++
"\   }
endfunction

call UpdateRainbowConf()

function! ReloadRainbow()
  if g:campo_theme_use_rainbow_parens
    if exists('g:rainbow_loaded')
      call UpdateRainbowConf()
      call rainbow#clear() | call rainbow#hook()
    endif
  else
    let g:rainbow_active = 0
    if exists('g:rainbow_loaded')
      call UpdateRainbowConf()
      call rainbow#clear()
    endif
  endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-TAGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags;$HOME


"-----------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
" 4. VISUALS
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LAYOUT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"////////////////////////////////////////////////////////////////
" CENTER THE BUFFER
"////////////////////////////////////////////////////////////////

 function! CenterPane()
  " centers the current pane as the middle 2 of 4 imaginary columns
  " should be called in a window with a single pane
  " Taken from https://dev.to/vinneycavallo/easily-center-content-in-vim
   lefta vnew
   wincmd w
   exec 'vertical resize '. string(&columns * 0.75)
 endfunction
nnoremap <leader>c :call CenterPane()<cr>

function! RemoveCenterPane()
  wincmd w
  close
endfunction
nnoremap <leader>cw :call RemoveCenterPane()<cr>


"////////////////////////////////////////////////////////////////
" TEXT ALIGNMENT PLUGIN
"////////////////////////////////////////////////////////////////
let b:lion_squeeze_spaces = 1


"////////////////////////////////////////////////////////////////
" STATUS LINE
"////////////////////////////////////////////////////////////////
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" alternative dark theme: 'campo-dark'
let g:campo_theme_use_rainbow_parens = 1
let s:dark_theme = 'campo-dark-green'
let s:light_theme = 'campo-light'

execute "autocmd ColorScheme " . s:dark_theme . " call ReloadRainbow()"
execute "autocmd ColorScheme " . s:light_theme . " call ReloadRainbow()"

" Switch between light and dark
map <leader>l :call ChangeBgTheme('light', 0)<cr>
map <leader>ll :call ChangeBgTheme('dark', 0)<cr>

function! ChangeBgTheme(bg, onlySetTheme)
  if a:bg =~ 'light'
    let s:rainbow_theme = 'light'
    let s:theme = s:light_theme
    exe 'colorscheme ' . s:theme
    set background=light
  else
    let s:rainbow_theme = 'dark'
    let s:theme = s:dark_theme
    " We have to set the theme twice in order to get its correct dark-theme colors.
    " Weird stuff.
    exe 'colorscheme ' . s:theme
    set background=dark
    exe 'colorscheme ' . s:theme
  endif

  if !a:onlySetTheme
    exec ':AirlineTheme ' . a:bg
  endif
endfunction

if s:default_bg =~ 'light'
  call ChangeBgTheme('light', 1)
else
  call ChangeBgTheme('dark', 1)
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HIGHLIGHTS - TODO, NOTE, FIXME, etc
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

augroup vimrc_annotated_todo
    au!
    " This was a major pain in the ass to get working...
    au Syntax * syn match cTodo /@\S\+/
          \ containedin=.*Comment,vimCommentTitle
augroup END

augroup vimrc_annotated_notes
    au!
    au Syntax * syn match cTodo /#\+ .\+$/
          \ containedin=.*Comment,vimCommentTitle
augroup END

"-----------------------------------------------------------------------------------------

"################################################################
"################################################################
"################################################################
" 5. HELPER FUNCTIONS
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BUILD COMMANDS
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

function! HideAsyncResults()
  call asyncrun#quickfix_toggle(g:build_window_size, 0)
endfunction

function! ToggleBuildResults()
  call asyncrun#quickfix_toggle(g:build_window_size)
endfunction

function! StopRunTask()
  AsyncStop
  call HideAsyncResults()
endfunction

function! ExecuteRunScript()
  exec "AsyncRun! -post=call\\ StopRunTask() ./run"
endfunction

function! SilentBuild()
  AsyncStop
  exec "AsyncRun! -save=2 -post=call\\ HideAsyncResults() ./build*"
endfunction

" Show results window the moment the async job starts
augroup vimrc
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(g:build_window_size, 1)
augroup END

" Toggle build results
noremap <F11> :call ToggleBuildResults()<cr>
nnoremap <leader>bc :call ToggleBuildResults()<cr>

" Hide build results and clear errors
noremap <F10> :call HideBuildResultsAndClearErrors()<cr>

" Execute build script
" Optimizations off
nnoremap <leader>b :AsyncRun! -save=2 ./build*<cr>
" Optimizations on
nnoremap <leader>bb :AsyncRun! -save=2 ./build* -o 1<cr>
nnoremap <F8> :call SilentBuild()<cr>

" Execute run script
nnoremap <leader>br :call ExecuteRunScript()<cr>
nnoremap <F9> :call ExecuteRunScript()<cr>

nnoremap <leader>bs :AsyncStop<cr>

"Go to next build error
nnoremap <F7> :cn<CR>
nnoremap <C-n> :cn<CR>

"Go to previous build error
nnoremap <F6> :cp<CR>
nnoremap <C-p> :cp<CR>


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
      " TODO: add --exclude=<file> support to filesearch plugin
      exec 'Fsgrep "' . l:term . '"'
    else
      " is pt faster than ag? I forget now and didn't document it
      "exec 'pt "' . l:term . '"'
      exec 'Ag "' . l:term . '"'
    endif
  endif
endfunction
map <leader>s :call Search()<cr>

command! -nargs=+ MyGrep execute 'silent grep! <args>' | copen 33


"////////////////////////////////////////////////////////////////
" FILESEARCH PLUGIN
"////////////////////////////////////////////////////////////////
 let g:filesearch_viewport_split_policy = "B"
 let g:filesearch_split_size = 10
 let g:filesearch_autodismiss_on_select = 0


"////////////////////////////////////////////////////////////////
" SELECTA -- find files with fuzzy-search
"////////////////////////////////////////////////////////////////
"
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


"-----------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
" 6. PERSONAL
"################################################################
"################################################################
"################################################################

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notes and other helpers
map <leader>pn :sp ~/.dev-scratchpad<cr>

let g:autotagStopAt = "$HOME"
