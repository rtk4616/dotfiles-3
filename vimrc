" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" load plugins
if !empty(glob("~/.vimrc.plugin"))
    source ~/.vimrc.plugin
endif

" filetype plugins
filetype plugin indent on

" syntax hightlighting
syntax on

" syntax coloring lines that are too long just slows down the world
" set synmaxcol=256

" set mapleader
let mapleader=" "
let maplocalleader = " "

" background
set background=dark

" hides buffers instead of closing them
set hidden

" do not reset position when switching buffers
set nostartofline

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" keep 200 lines of command line history
set history=200

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" redraw lazy
set lazyredraw

" tty scroll
set ttyscroll=3

" set linenumbers
set number

" don't automagically write on :next
set noautowrite

" do incremental searching
set incsearch

" hightlight all search matches
set hlsearch

" show matching bracket
set showmatch

" we have a fast terminal
set ttyfast

" use the OS clipboard
set clipboard=unnamedplus

" auto. reread file when changed outside of vim
set ar

" ask to save files when closing vim
set confirm

" case insensitive, but be smart
set ignorecase
set smartcase

" set escape timeout
set ttimeoutlen=0

" keep lines before/beneath cursor
set scrolloff=5
set sidescrolloff=5

" change directory to the current buffer when opening files.
"set autochdir
autocmd BufEnter * silent! lcd %:p:h

" statusline show last line
set laststatus=2

" dont show mode in second line
set noshowmode

" avoid all hit-enter prompts and shorten some other info prompts
set shortmess=atI

" backspace delete shiftwidth of spaces
set smarttab

" colordepth
set t_Co=256

" tell vim to keep a backup file
set backup

" tagfiles
set tags=./tags;

" prevent backups from overwriting each other. appends reversed path to the
" backup file.
au BufWritePre * let &backupext = '@'.substitute(expand('%:p:h'), '/', '%', 'g').'~'

" Remember info about open buffers on close
set viminfo^=%

" tell vim where to put its backup files
set backupdir=~/.vim/tmp

" tell vim where to put swap files
set directory=~/.vim/swp

" persistent undo history across sessions
set undofile
set undodir=~/.vim/undo

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" complete options
set completeopt+=menuone
set completeopt-=preview
set pumheight=8

" formatoptions
autocmd FileType * setlocal formatoptions=crqnbj

" 8 spaces are bad, use 4 and auto expand them
set expandtab
set tabstop=4
set shiftwidth=4

" always round indents to multiple of shiftwidth
set shiftround

" Turn on the WiLd menu
set wildmenu
set wildignore=*.o,*.d,*~,*.pyc,*.class
set wildmode=longest,list,full
set wildignorecase

" show invisible chars
set listchars=tab:»·,trail:·,extends:…
set list

" % to also switch between begin/end
runtime macros/matchit.vim

" highlight extra whitespaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" For all text files set 'textwidth' to 80 characters.
set textwidth=80

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" ========colors/appearance

" colorscheme
colorscheme codeschool

" use background color of terminal
hi Normal ctermbg=none
hi NonText ctermbg=none

" light cursor line background
hi CursorLine ctermbg=239 cterm=none

" dark lineNr column
hi LineNr ctermfg=242 ctermbg=235

" mark current linenumber
hi CursorLineNr term=bold cterm=bold ctermfg=Yellow gui=bold guifg=Yellow

" search highlights
hi Search cterm=none ctermfg=black ctermbg=yellow

" underline errors (only needed for the highlighted cursorline :/)
hi SpellBad cterm=italic,underline

" colors for completionmenu
highlight Pmenu ctermbg=242 ctermfg=153

" only enable cursorline in focused window
set cul
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
    autocmd BufEnter * set cul
    autocmd BufLeave * set nocul
augroup END

" make gvim look like vim :)
if has("gui_running")
    set guifont=Monospace\ 11
    hi Normal guifg=#dcdccc guibg=#3f3f3f
    set guioptions-=m " Remove menu
    set guioptions-=T " Remove toolbar
    set guioptions-=r " Remove right scrollbar
    set guioptions-=e " Use curses rendering for tab pages
    set guioptions+=c " Use curses for simple dialog boxes
    set guioptions-=i " No vim icon
    set guioptions-=L " No left scrollbar
endif

" ========commands/functions

"spelling error
command! W w
command! Q q
command! Wq wq
command! WQ wq

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

" open commands for file lists
command! -complete=file -nargs=+ Etabe call s:ETW('tabnew', <f-args>)
command! -complete=file -nargs=+ Enew call s:ETW('new', <f-args>)
command! -complete=file -nargs=+ Evnew call s:ETW('vnew', <f-args>)
command! -complete=file -nargs=+ E call s:ETW('edit', <f-args>)
function! s:ETW(what, ...)
    for f1 in a:000
        let files = glob(f1)
        if files == ''
            execute a:what . ' ' . escape(f1, '\ "')
        else
            for f2 in split(files, "\n")
                execute a:what . ' ' . escape(f2, '\ "')
            endfor
        endif
    endfor
endfunction

" fix all whitespaces
command! WsFix call WhitespaceFix()
function! WhitespaceFix()
    if !&binary && &filetype != 'diff'
        let l:winview = winsaveview()
        silent! %s/\s\+$//
        call winrestview(l:winview)
    endif
endfunction

" toggles the quickfix and location window.
command! Qtoggle call QFixToggle(0)
command! Ltoggle call QFixToggle(1)
function! QFixToggle(loc)
    if a:loc
        cclose
    else
        lclose
    endif

    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            cclose
            lclose
            return
        endif
    endfor

    if a:loc
        lwindow
    else
        cwindow
    endif
endfunction

" toggle colored right border after 80 chars
set colorcolumn=0
let s:color_column_old = 81
command! -bang -nargs=? ColorToggle call ToggleColorColumn(<bang>0)
function! ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction

" toggle side effects on yank register when deleting/modifying text
function! ToggleSideEffects()
    if mapcheck("dd", "n") == ""
        noremap dd "_dd
        noremap D "_D
        noremap d "_d
        noremap X "_X
        noremap x "_x
        xnoremap <expr> p 'pgv"'.v:register.'y'
        echo 'side effects off'
    else
        unmap dd
        unmap D
        unmap d
        unmap X
        unmap x
        xunmap p
        echo 'side effects on'
    endif
endfunction

" ========keybindings

" MapFastKeycode: helper for fast keycode mappings
" makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
function! <SID>MapFastKeycode(key, keycode)
    if s:fast_i == 46
        echohl WarningMsg
        echomsg "Unable to map ".a:key.": out of spare keycodes"
        echohl None
        return
    endif
    let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
    exec 'set '.vkeycode.'='.a:keycode
    exec 'map '.vkeycode.' '.a:key
    exec 'imap '.vkeycode.' '.a:key
    let s:fast_i += 1
endfunction
let s:fast_i = 0

call <SID>MapFastKeycode('<S-Tab>', "\e}")
call <SID>MapFastKeycode('<C-Tab>', "\e{")
call <SID>MapFastKeycode('<M-q>', "\eq")
call <SID>MapFastKeycode('<M-h>', "\eh")
call <SID>MapFastKeycode('<M-j>', "\ej")
call <SID>MapFastKeycode('<M-k>', "\ek")
call <SID>MapFastKeycode('<M-l>', "\el")
call <SID>MapFastKeycode('<M-d>', "\ed")
call <SID>MapFastKeycode('<C-q>', "\ed")

" ditch shift for command mode
map ; :

" toggle sideffects
nnoremap <leader>, :call ToggleSideEffects()<CR>

" clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>:echo<CR>

" Don't use Ex mode, use Q for formatting
noremap Q gq

"w!! writes file with root rights
cnoremap w!! w !sudo tee % >/dev/null

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" switch buffers/tabs
nnoremap <leader>a :bprevious<CR>
nnoremap <leader>s :bnext<CR>
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>h gT
nnoremap <leader>l gt
nnoremap ,         <C-^>

" switch to numbered buffer
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" open current file 'fullscreen' / in new tab with ctrl+space
nnoremap <C-@>     :tabedit %<cr>

" easier split window navigation
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-h>     <C-w>h
nnoremap <C-l>     <C-w>l

" Y yanks till end of line
nnoremap Y y$

" delete everything but selection
vnoremap <leader>d :<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>
nnoremap <leader>d <S-v>:<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>

" apply q macro with one key
nnoremap \ @q

" local settings
if !empty(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
