"first run this command 



" General Neovim settings
set number                   " Show line numbers
set norelativenumber         " Disable relative line numbers
set autoindent               " Enable auto indentation
set tabstop=4                " Number of spaces in a tab
set shiftwidth=4             " Number of spaces to use for autoindent
set smarttab                 " Use 'shiftwidth' when inserting a tab
set softtabstop=4            " Number of spaces that <Tab> counts for in insert mode
set mouse=a                  " Enable mouse support
set encoding=UTF-8           " Set encoding to UTF-8
set completeopt=menu,menuone,noinsert " Completion options

" Plugin management using vim-
call plug#begin('~/.config/nvim/plugged')

Plug 'folke/tokyonight.nvim'
Plug 'turbio/bracey.vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'lifepillar/pgsql.vim'
Plug 'ap/vim-css-color'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'puremourning/vimspector'

" End of plugin declarations
call plug#end()

" Load Vimspector manually as it was cloned manually

syntax enable
set termguicolors " Enable 24-bit RGB colors
let g:tokyonight_style = "storm" " Available styles: night, storm, day
let g:tokyonight_terminal_colors = 1
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = ['qf', 'vista_kind', 'terminal', 'packer']
let g:tokyonight_colors = {'hint': 'orange', 'error': '#ff0000'}

colorscheme tokyonight


" Key mappings for split layout and functionality
nnoremap <C-b> :call ToggleNERDTree()<CR>                         " Ctrl-b to toggle file explorer
nnoremap <C-x> :call ToggleTerminal()<CR>                        " Ctrl-x to toggle terminal

" Switch between splits
nnoremap <C-left> :wincmd h<CR>                                  " Ctrl-left to switch to the left split (file explorer)
nnoremap <C-right> :wincmd l<CR>                                 " Ctrl-right to switch to the right split (terminal)

" Switch to terminal or editor
nnoremap <C-t> :wincmd l<CR>                                    " Ctrl-t to switch to the terminal
nnoremap <C-e> :wincmd h<CR>                                    " Ctrl-e to switch to the editor

" Additional key mappings for terminal mode
tnoremap <C-left> <C-\><C-n>:wincmd h<CR>                       " Ctrl-left in terminal to switch to the left split
tnoremap <C-right> <C-\><C-n>:wincmd l<CR>                      " Ctrl-right in terminal to switch to the right split

" NERDTree specific key mappings
autocmd FileType nerdtree nnoremap <buffer> <C-n> :call CreateNewFile()<CR>    " Ctrl-n to create a new file in NERDTree
autocmd FileType nerdtree nnoremap <buffer> <leader>m :call CreateNewDirectory()<CR> " Leader + m to create a new directory in NERDTree
autocmd FileType nerdtree nnoremap <buffer> <CR> :NERDTreeMirror<CR>    " Enter to open the selected file

" Exit Neovim completely
nnoremap <C-q> :qa!<CR>                                         " Ctrl-q to exit Neovim

" Airline settings
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" NERDTree configuration
let g:NERDTreeDirArrowExpandable = "+"
let g:NERDTreeDirArrowCollapsible = "~"

" Set the color scheme
colorscheme 

" Vimspector configuration
let g:vimspector_enable_mappings = 'HUMAN'                      " Enable human-readable mappings for Vimspector

" Function to toggle NERDTree visibility
function! ToggleNERDTree()
    if bufexists(bufnr('NERD_tree'))
        :NERDTreeToggle
    else
        :NERDTree
    endif
endfunction

" Function to toggle terminal visibility
function! ToggleTerminal()
    " Check if terminal is already open
    let l:term_exists = bufname() =~ 'term://'
    if l:term_exists
        " If terminal is open, close it
        :bd!
    else
        " If terminal is not open, open it
        :vsplit term://bash
        :wincmd l
    endif
endfunction

" Function to create a new file in NERDTree
function! CreateNewFile()
    let l:file_name = input('New file name: ')
    if empty(l:file_name)
        return
    endif
    execute 'silent !touch ' . shellescape(l:file_name)
    :NERDTreeRefreshRoot
    :execute 'edit ' . fnameescape(l:file_name)
endfunction

" Function to create a new directory in NERDTree
function! CreateNewDirectory()
    let l:dir_name = input('New directory name: ')
    if empty(l:dir_name)
        return
    endif
    execute 'silent !mkdir ' . shellescape(l:dir_name)
    :NERDTreeRefreshRoot
endfunction

" Use <Tab> and <S-Tab> to navigate completion menu from coc.nvim
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <CR> to confirm completion (like Enter)
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"


autocmd FileType nerdtree nmap <buffer> d :call NERDTreeCreateFile()<CR>

function! NERDTreeCreateFile()
  let l:filename = input('New file name: ')
  if empty(l:filename)
    return
  endif
  execute '!touch ' . shellescape(l:filename)
  :NERDTreeRefreshRoot
endfunction





autocmd FileType nerdtree nmap <buffer> a :call NERDTreeCreateFolder()<CR>


function! NERDTreeCreateFolder()
  let l:dirname = input('New folder name: ')
  if empty(l:dirname)
    return
  endif
  execute '!mkdir -p ' . shellescape(l:dirname)
  :NERDTreeRefreshRoot
endfunction



autocmd FileType nerdtree nmap <buffer> <Del> :call NERDTreeDeleteEntry()<CR>


function! NERDTreeDeleteEntry()
  let l:node = g:NERDTreeFileNode.GetSelected()
  if l:node ==# {} || !has_key(l:node, 'path')
    echo "No file/folder selected"
    return
  endif
  let l:target = l:node.path.str()

  if confirm("Delete " . l:target . "?", "&Yes\n&No") == 1
    " Use system call to safely delete outside buffer
    call system('rm -rf ' . shellescape(l:target))
    execute 'NERDTreeRefreshRoot'
  endif
endfunction




" ─────────────────────────────────────────────
" NERDTree: Expand/Collapse folders and open files
" ─────────────────────────────────────────────

" Expand with Enter, collapse with Shift+Enter
autocmd FileType nerdtree nnoremap <buffer> <CR> :call NERDTreeExpandOrOpen()<CR>
autocmd FileType nerdtree nnoremap <buffer> <S-CR> :call NERDTreeCollapseNode()<CR>

function! NERDTreeExpandOrOpen()
  if !exists("*g:NERDTreeFileNode.GetSelected")
    return
  endif

  let l:node = g:NERDTreeFileNode.GetSelected()

  if type(l:node) != type({})
    return
  endif

  if has_key(l:node, 'isDirectory') && l:node.isDirectory
    if has_key(l:node, 'isOpen') && !l:node.isOpen
      call l:node.open()
    else
      call l:node.activate()
    endif
  else
    call l:node.activate()
  endif
endfunction

function! NERDTreeCollapseNode()
  if !exists("*g:NERDTreeFileNode.GetSelected")
    return
  endif

  let l:node = g:NERDTreeFileNode.GetSelected()

  if type(l:node) != type({})
    return
  endif

  if has_key(l:node, 'isDirectory') && l:node.isDirectory && has_key(l:node, 'isOpen') && l:node.isOpen
    call l:node.close()
  endif
endfunction





                                                                      
┌──(venv)─(hounaar㉿kali)-[~/.config/nvim]
└─$ ls               
init.vim  plugged
                                                                      
┌──(venv)─(hounaar㉿kali)-[~/.config/nvim]
└─$ cat init.vim
"first run this command 



" General Neovim settings
set number                   " Show line numbers
set norelativenumber         " Disable relative line numbers
set autoindent               " Enable auto indentation
set tabstop=4                " Number of spaces in a tab
set shiftwidth=4             " Number of spaces to use for autoindent
set smarttab                 " Use 'shiftwidth' when inserting a tab
set softtabstop=4            " Number of spaces that <Tab> counts for in insert mode
set mouse=a                  " Enable mouse support
set encoding=UTF-8           " Set encoding to UTF-8
set completeopt=menu,menuone,noinsert " Completion options

" Plugin management using vim-
call plug#begin('~/.config/nvim/plugged')

Plug 'folke/tokyonight.nvim'
Plug 'turbio/bracey.vim'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'lifepillar/pgsql.vim'
Plug 'ap/vim-css-color'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'puremourning/vimspector'

" End of plugin declarations
call plug#end()

" Load Vimspector manually as it was cloned manually

syntax enable
set termguicolors " Enable 24-bit RGB colors
let g:tokyonight_style = "storm" " Available styles: night, storm, day
let g:tokyonight_terminal_colors = 1
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = ['qf', 'vista_kind', 'terminal', 'packer']
let g:tokyonight_colors = {'hint': 'orange', 'error': '#ff0000'}

colorscheme tokyonight


" Key mappings for split layout and functionality
nnoremap <C-b> :call ToggleNERDTree()<CR>                         " Ctrl-b to toggle file explorer
nnoremap <C-x> :call ToggleTerminal()<CR>                        " Ctrl-x to toggle terminal

" Switch between splits
nnoremap <C-left> :wincmd h<CR>                                  " Ctrl-left to switch to the left split (file explorer)
nnoremap <C-right> :wincmd l<CR>                                 " Ctrl-right to switch to the right split (terminal)

" Switch to terminal or editor
nnoremap <C-t> :wincmd l<CR>                                    " Ctrl-t to switch to the terminal
nnoremap <C-e> :wincmd h<CR>                                    " Ctrl-e to switch to the editor

" Additional key mappings for terminal mode
tnoremap <C-left> <C-\><C-n>:wincmd h<CR>                       " Ctrl-left in terminal to switch to the left split
tnoremap <C-right> <C-\><C-n>:wincmd l<CR>                      " Ctrl-right in terminal to switch to the right split

" NERDTree specific key mappings
autocmd FileType nerdtree nnoremap <buffer> <C-n> :call CreateNewFile()<CR>    " Ctrl-n to create a new file in NERDTree
autocmd FileType nerdtree nnoremap <buffer> <leader>m :call CreateNewDirectory()<CR> " Leader + m to create a new directory in NERDTree
autocmd FileType nerdtree nnoremap <buffer> <CR> :NERDTreeMirror<CR>    " Enter to open the selected file

" Exit Neovim completely
nnoremap <C-q> :qa!<CR>                                         " Ctrl-q to exit Neovim

" Airline settings
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" NERDTree configuration
let g:NERDTreeDirArrowExpandable = "+"
let g:NERDTreeDirArrowCollapsible = "~"

" Set the color scheme
colorscheme 

" Vimspector configuration
let g:vimspector_enable_mappings = 'HUMAN'                      " Enable human-readable mappings for Vimspector

" Function to toggle NERDTree visibility
function! ToggleNERDTree()
    if bufexists(bufnr('NERD_tree'))
        :NERDTreeToggle
    else
        :NERDTree
    endif
endfunction

" Function to toggle terminal visibility
function! ToggleTerminal()
    " Check if terminal is already open
    let l:term_exists = bufname() =~ 'term://'
    if l:term_exists
        " If terminal is open, close it
        :bd!
    else
        " If terminal is not open, open it
        :vsplit term://bash
        :wincmd l
    endif
endfunction

" Function to create a new file in NERDTree
function! CreateNewFile()
    let l:file_name = input('New file name: ')
    if empty(l:file_name)
        return
    endif
    execute 'silent !touch ' . shellescape(l:file_name)
    :NERDTreeRefreshRoot
    :execute 'edit ' . fnameescape(l:file_name)
endfunction

" Function to create a new directory in NERDTree
function! CreateNewDirectory()
    let l:dir_name = input('New directory name: ')
    if empty(l:dir_name)
        return
    endif
    execute 'silent !mkdir ' . shellescape(l:dir_name)
    :NERDTreeRefreshRoot
endfunction

" Use <Tab> and <S-Tab> to navigate completion menu from coc.nvim
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <CR> to confirm completion (like Enter)
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"


autocmd FileType nerdtree nmap <buffer> d :call NERDTreeCreateFile()<CR>

function! NERDTreeCreateFile()
  let l:filename = input('New file name: ')
  if empty(l:filename)
    return
  endif
  execute '!touch ' . shellescape(l:filename)
  :NERDTreeRefreshRoot
endfunction





autocmd FileType nerdtree nmap <buffer> a :call NERDTreeCreateFolder()<CR>


function! NERDTreeCreateFolder()
  let l:dirname = input('New folder name: ')
  if empty(l:dirname)
    return
  endif
  execute '!mkdir -p ' . shellescape(l:dirname)
  :NERDTreeRefreshRoot
endfunction



autocmd FileType nerdtree nmap <buffer> <Del> :call NERDTreeDeleteEntry()<CR>


function! NERDTreeDeleteEntry()
  let l:node = g:NERDTreeFileNode.GetSelected()
  if l:node ==# {} || !has_key(l:node, 'path')
    echo "No file/folder selected"
    return
  endif
  let l:target = l:node.path.str()

  if confirm("Delete " . l:target . "?", "&Yes\n&No") == 1
    " Use system call to safely delete outside buffer
    call system('rm -rf ' . shellescape(l:target))
    execute 'NERDTreeRefreshRoot'
  endif
endfunction




" ─────────────────────────────────────────────
" NERDTree: Expand/Collapse folders and open files
" ─────────────────────────────────────────────

" Expand with Enter, collapse with Shift+Enter
autocmd FileType nerdtree nnoremap <buffer> <CR> :call NERDTreeExpandOrOpen()<CR>
autocmd FileType nerdtree nnoremap <buffer> <S-CR> :call NERDTreeCollapseNode()<CR>

function! NERDTreeExpandOrOpen()
  if !exists("*g:NERDTreeFileNode.GetSelected")
    return
  endif

  let l:node = g:NERDTreeFileNode.GetSelected()

  if type(l:node) != type({})
    return
  endif

  if has_key(l:node, 'isDirectory') && l:node.isDirectory
    if has_key(l:node, 'isOpen') && !l:node.isOpen
      call l:node.open()
    else
      call l:node.activate()
    endif
  else
    call l:node.activate()
  endif
endfunction

function! NERDTreeCollapseNode()
  if !exists("*g:NERDTreeFileNode.GetSelected")
    return
  endif

  let l:node = g:NERDTreeFileNode.GetSelected()

  if type(l:node) != type({})
    return
  endif

  if has_key(l:node, 'isDirectory') && l:node.isDirectory && has_key(l:node, 'isOpen') && l:node.isOpen
    call l:node.close()
  endif
endfunction
