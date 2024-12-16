syntax enable

filetype on
filetype indent on

" Setting mapleader to SPC
let mapleader=" "

let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_winsize=75

" Configuration for NERDCommenter -- begin
let g:NERDCreateDefaultMappings = 1                                     " Create default mappings
let g:NERDSpaceDelims = 1                                               " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                                           " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                                         " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1                                            " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }   " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1                                         " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1                                    " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1                                       " Enable NERDCommenterToggle to check all selected lines is commented or not
" -- end

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee %> /dev/null' <bar> edit!

set ruler " Always show current position
set cmdheight=1
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set path+=**
set nocompatible
set cursorline
set colorcolumn=80
set foldcolumn=1
set nowrap
set number relativenumber
set splitbelow splitright
set shiftwidth=4 tabstop=4 softtabstop=4
set shiftround
set expandtab autoindent smartindent
set showmatch showcmd
set noshowmode
set ignorecase smartcase                " Ignore case when searching
set incsearch hlsearch                  " Highlight search results
set wildmenu wildmode=list,longest,full " Turn on the wildmenu
set history=1000
set nobackup nowb noswapfile
set clipboard=unnamedplus
set lazyredraw                          " Don't redraw while executing macros (good performance config)
set termguicolors
set scrolloff=8
set list
" set listchars=eol:↵,tab:>-,space:·,nbsp:␣,trail:~,multispace:\|···
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set encoding=utf8

" Mappings
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
nnoremap n nzz
nnoremap N Nzz


nnoremap <SPACE> <Nop>
nnoremap <Leader>h :nohlsearch<CR>

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>K
nnoremap <C-L> <C-W>l


map <leader>bd :Bclose<cr>:tabclose<cr>gT
map <leader>ba :bufdo bd<cr>
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bq :e ~/buffer<cr>
map <leader>bx :e ~/buffer.md<cr>

map <leader>vn :cn<cr>
map <leader>vp :cp<cr>
map <leader>vo :copen<cr>

map <leader>cd :cd %:p:h<cr>:pwd<cr>

map <leader>e :NERDTreeToggle<cr>
map <leader>u :UndotreeToggle<cr>
map <leader>tf :NERDTreeToggle<cr>

map <leader>fs :w!<cr>

map <leader>h  :nohl<cr>

map <leader>;o :TagbarToggle<cr>

map <leader>tN :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tn :tabnext
map <leader>tp :tabprev
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

map <leader>Tw :FixWhitespace<cr>

map <leader>ss :setlocal spell!<cr>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

map <leader>pp :setlocal paste!<cr>
map <leader>q  :q<cr>
map <leader>z  :Goyo<cr>

" Indent guide default mapping <Leader>ig
" Default mapping for NERDCommenter -- Begin
" [count]<leader>cc |NERDCommenterComment           " Comment out the current line or text selected in visual mode.
" [count]<leader>cn |NERDCommenterNested|           " Same as cc but forces nesting.
" [count]<leader>c<space> |NERDCommenterToggle|     " Toggles the comment state of the selected line(s). If the topmost selected line is commented, all selected lines are uncommented and vice versa.
" [count]<leader>cm |NERDCommenterMinimal|          " Comments the given lines using only one set of multipart delimiters.
" [count]<leader>ci |NERDCommenterInvert|           " Toggles the comment state of the selected line(s) individually.
" [count]<leader>cs |NERDCommenterSexy|             " Comments out the selected lines with a pretty block formatted layout.
" [count]<leader>cy |NERDCommenterYank|             " Same as cc except that the commented line(s) are yanked first.
" <leader>c$ |NERDCommenterToEOL|                   " Comments the current line from the cursor to the end of line.
" <leader>cA |NERDCommenterAppend|                  " Adds comment delimiters to the end of line and goes into insert mode between them.
"            |NERDCommenterInsert|                  " Adds comment delimiters at the current cursor position and inserts between. Disabled by default.
" <leader>ca |NERDCommenterAltDelims|               " Switches to the alternative set of delimiters.
" [count]<leader>cl |NERDCommenterAlignLeft
" [count]<leader>cb |NERDCommenterAlignBoth         " Same as |NERDCommenterComment| except that the delimiters are aligned down the left side (<leader>cl) or both sides (<leader>cb).
" [count]<leader>cu |NERDCommenterUncomment|        " Uncomments the selected line(s).
" -- End

try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'dracula/vim', {'name':'dracula'}
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bronson/vim-trailing-whitespace'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'justinmk/vim-sneak'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'baskerville/vim-sxhkdrc'
Plug 'waycrate/swhkd'
Plug 'mbbill/undotree'
Plug 'delphinus/vim-firestore'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'habamax/vim-asciidoctor'
call plug#end()


colorscheme dracula

let g:sneak#label = 1

hi Normal guibg=NONE ctermbg=NONE

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" " Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" FZF Bindings
nnoremap <silent> <leader>sf <cmd>Files<cr>
nnoremap <silent> <leader>f <cmd>Files<cr>
nnoremap <silent> <leader>st <cmd>RG<cr>
nnoremap <silent> <leader>sg <cmd>RG<cr>
nnoremap <silent> <leader>sb <cmd>Buffers<cr>
nnoremap <silent> <leader>bb <cmd>Buffers<cr>
nnoremap <silent> <leader>sh <cmd>Helptags<cr>
nnoremap <silent> <leader>sc <cmd>Changes<cr>
nnoremap <silent> <leader>sm <cmd>Marks<cr>
nnoremap <silent> <leader>sj <cmd>Jumps<cr>
nnoremap <silent> <leader>sC <cmd>Commands<cr>


