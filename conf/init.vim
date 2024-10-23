"first run this command 

sudo apt install dos2unix
sudo dos2unix ~/.config/nvim/init.vim



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

" Plugin management using vim-plug
call plug#begin()

" Plugin declarations "
Plug 'turbio/bracey.vim'
Plug 'https://github.com/tpope/vim-surround'                    " Surrounding text objects
Plug 'https://github.com/preservim/nerdtree'                    " File explorer
Plug 'https://github.com/tpope/vim-commentary'                  " Easy commenting
Plug 'https://github.com/vim-airline/vim-airline'               " Status bar
Plug 'https://github.com/lifepillar/pgsql.vim'                  " PostgreSQL syntax highlighting
Plug 'https://github.com/ap/vim-css-color'                      " CSS color preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes'         " Collection of color schemes
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'} " Code completion
Plug 'https://github.com/ryanoasis/vim-devicons'                " File icons
Plug 'https://github.com/preservim/tagbar'                      " Code navigation with tags
Plug 'https://github.com/terryma/vim-multiple-cursors'          " Multiple cursor support
Plug 'puremourning/vimspector'

.
" End of plugin declarations
call plug#end()

" Load Vimspector manually as it was cloned manually


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
colorscheme jellybeans

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
