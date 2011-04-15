filetype indent on
set tabstop=4
set smarttab
set shiftwidth=4
set autoindent
set expandtab
syntax on
set number
set wildmenu
set mouse=a

" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Enable filetype plugins and indention
filetype on
filetype plugin on

" prefer unix over windows over os9 formats
set fileformats=unix,dos,mac

" utf-8 default encoding
set enc=utf-8

" keep some more lines for scope
set scrolloff=5

" ; is an alias for :
nnoremap ; :

" template language support (SGML / XML too)
" ------------------------------------------
" and disable taht stupid html rendering (like making stuff bold etc)

fun! s:SelectHTML()
let n = 1
while n < 50 && n < line("$")
  " check for jinja
  if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
    set ft=htmljinja
    return
  endif
  " check for django
  if getline(n) =~ '{%\s*\(extends\|block\|comment\|ssi\|if\|for\|blocktrans\)\>'
    set ft=htmldjango
    return
  endif
  " check for mako
    if getline(n) =~ '<%\(def\|inherit\)'
      set ft=mako
      return
    endif
    " check for genshi
    if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
      set ft=genshi
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun

autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
autocmd BufNewFile,BufRead *.html,*.htm call s:SelectHTML()

" CSS
" ---
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Javascript
" ----------
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=79
let javascript_enable_domhtmlcss=1

