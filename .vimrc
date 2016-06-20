""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""                  PERSONAL CONFIG FILE FOR VIM                """
"""                                                              """
"""                      R. Dan Morouney 2015                    """
"""                     moro1422@mylaurier.ca                    """
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd!
set number
set autoindent
set cindent
set nocompatible
syntax enable
set encoding=utf-8
set showcmd
filetype plugin indent on
set nowrap
set tabstop=1 shiftwidth=2
"set expandtab
set backspace=indent,eol,start
set hlsearch
set incsearch
set paste
syntax on
filetype on

execute pathogen#infect()

augroup filetypedetect
    au! BufRead,BufNewFile   *.r     setfiletype r
    au! BufRead,BufNewFile   *.h     setfiletype h
augroup END

augroup vimrc_filetype
    autocmd!
    autocmd FileType c call s:MyCSettings()
    autocmd FileType r call s:MyCSettings()
    autocmd FileType h call s:MyCSettings()
    autocmd FileType vim call s:MyVimSettings()
augroup end

map _ :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

function! s:MyCSettings()
    autocmd BufNewFile * call s:insert ()
    autocmd BufWrite * call s:update ()
    map - :s/^/\/\//<CR>:nohlsearch<CR>
endfunction

function! s:MyVimSettings()
    map - :s/^/\"/<CR>:nohlsearch<CR>
endfunction

function s:filetype ()
    let s:file = expand("<afile>:t")
    let l:ft = &ft
    if l:ft ==# 'sh'
        let s:comment = "#"
        let s:type = s:comment . "!/usr/bin/env bash"
    elseif l:ft ==# 'python'
        let s:comment = "#"
        let s:type = s:comment . "-*- coding:utf-8 -*-"
    elseif l:ft ==# 'perl'
        let s:comment = "#"
        let s:type = s:comment . "!/usr/bin/env perl"
    elseif l:ft ==# 'vim'
        let s:comment = "\""
        let s:type = s:comment . " Vim File"
    elseif l:ft ==# 'c' || l:ft ==# 'cpp' || l:ft ==# 'h' || l:ft ==# 'r'
        let s:comment = "\/\/"
        let s:type = s:comment . " C/C++ File"
    elseif l:ft==# 'rst'
        let s:comment = ".."
        let s:type = s:comment . " reStructuredText "
    elseif l:ft==# 'php'
        let s:comment = "\/\/"
        let s:type = s:comment . " Php File "
    elseif l:ft ==# 'javascript'
        let s:comment = "\/\/"
        let s:type = s:comment . " Javascript File"
    else
        let s:comment = "#"
        let s:type = s:comment . " Text File"
    endif
    unlet s:file
endfunction

function s:insert ()
    call s:filetype ()
    let s:line = s:comment . "//////////////////////////////////////////////////////////////////"
    let s:author = s:comment .    " AUTHOR:   Robert Morouney"
    let s:file = s:comment .      " FILE:     " . expand("<afile>")
    let s:email = s:comment .     " EMAIL:    robert@morouney.com "
    let s:created = s:comment .   " CREATED:  " . strftime ("%Y-%m-%d %H:%M:%S")
    let s:modified = s:comment .  " MODIFIED: " . strftime ("%Y-%m-%d %H:%M:%S")

    call setline (1, s:line)
    call setline (2, s:author)
    call setline (3, s:email)
    call setline (4, s:file)
    call setline (5, s:created)
    call setline (6, s:modified)
    call setline (7, s:line)
    
    let l:ft = &ft
    if l:ft ==# 'c'
        echo "CANT GET NO MORE FREE RANDY"
        call setline (8, "")
        call setline (9, "#include <stdio.h>")
        call setline (10, "")
        call setline (11, "int main(int argc, char *argv[]) {")
        call setline (12, "      ")
        call setline (13, "    return 0;")
        call setline (14, "}")
        call cursor(12,5)
    endif
    
    if l:ft ==# 'h'
        let s:fff   = expand("<afile>")
        let s:fname = toupper(substitute(s:fff, '\.', '\_', 'g'))
        echo "THIS IS A HEADER FILE ~~> ^^ "
        call setline ( 8,  "#ifndef " . s:fname )
        call setline ( 9,  "    #define " . s:fname )
        call setline ( 10, "    #include <stddef.h>" )
        call setline ( 11, "" )
        call setline ( 12, "    " )
        call setline ( 13, "" )
        call setline ( 14, "#endif" )
        call cursor( 12, 4 )
        unlet s:fname
        unlet s:fff
    endif

    if l:ft ==# 'r'
        let s:fff   = expand("<afile>")
        let s:fname = toupper(substitute(s:fff, '\.', '\_', 'g'))
        echo "THIS IS A RESTRICTED FILE ~~> DONT TOUCH 8P "
        call setline ( 8,  "#ifndef " . s:fname )
        call setline ( 9,  "    #define " . s:fname )
        call setline ( 10, "" )
        call setline ( 11, "    " )
        call setline ( 12, "" )
        call setline ( 13, "#endif" )
        call cursor( 11, 4 )
        unlet s:fname
        unlet s:fff
    endif

    unlet l:ft
    unlet s:comment
    unlet s:type
    unlet s:line
    unlet s:author
    unlet s:file
    unlet s:email
    unlet s:created
    unlet s:modified
endfunction

function s:update()
    call s:filetype ()

    let s:pattern = s:comment . " MODIFIED: [0-9]"
    let s:line = getline (6)
   
    if match (s:line, s:pattern) != -1
        let s:modified = s:comment . " MODIFIED: " . strftime ("%Y-%m-%d %H:%M:%S")
        call setline (6, s:modified)
        unlet s:modified
    endif

    unlet s:comment
    unlet s:pattern
    unlet s:line
endfunction

autocmd BufNewFile * call s:insert ()
autocmd BufWritePre * call s:update ()

set runtimepath^=~/.vim/bundle/ctrlp.vim
autocmd VimEnter * NERDTree
autocmd BufEnter * NERDTreeMirror

autocmd VimEnter * wincmd w

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

autocmd FileType python nnoremap <silent> <F12> :!clear;python %<cr>
autocmd FileType julia nnoremap <silent> <F12> :!clear;python %<cr>
autocmd FileType ruby nnoremap <silent> <F12> :!clear;python %<cr>
autocmd FileType c nnoremap <silent> <F12> :!clear;gcc %;./a.out;rm -f a.out<cr>

