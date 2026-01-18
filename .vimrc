language message en_US.UTF-8    " language set US

syntax on                        " Enable syntax highlighting.
filetype plugin indent on        " Enable file type based indentation.

set autoindent                   " Respenct indentation when starting a new line.
set expandtab                    " Expand tabs to spaces. Essential in Python.
set tabstop=4                    " Number of spaces tab is counted for.
set shiftwidth=4                 " Number of spaces to use for autoindent.

set number                       " Add line numbers.
"set relativenumber              " Display relative column numbers.

set backspace=2                  " Fix backspace behavior on most terminals.

"colorscheme murphy               " Change a colorscheme.
"colorscheme blue               " Change a colorscheme.
"colorscheme desert

packloadall                      " All plugins load.
silent! helptags ALL             " All plugins help file load.

" Window change key mapping
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

"set foldmethod=indent           " Indentation-based folding.

set wildmenu                    " Enable enhanced tab autocomplete.
set wildmode=list:longest,full  " Complete till longest string, then open menu.

" NERDTreeの設定
let NERDTreeShowHidden=1        " See hidden file.
command! NT NERDTree
let NERDTreeShowBookmarks=1
let NERDTreeAutoRefreshOnWrite = 1

" ファイル作成・削除時に自動更新
" autocmd BufWritePost * NERDTreeFocus | execute 'normal R' | wincmd p



set clipboard=unnamed           " Clipboard on.

" Plugin-related settings below are commented out. Uncomment them to enable
" the plugin functionality once you download the plugins.

" autocmd VimEnter * NERDTree     " Enable NERDTree on Vim startup.
" Autoclose NERDTree if it's the only open window left.
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&
"   \ b:NERDTree.isTabTree()) | q | endif


let g:netrw_hide = 0             " netrw see hidden file .
"let NERDTreeHijackNetrw = 0      "NERDTree not use Vinegar
let g:NERDTreeChDirMode = 2      " NERDTreeでディレクトリを開くと自動でvimの作業ディレクトに変更される

set hlsearch                     " hilight
set virtualedit=block


" NERDCommenter設定
let g:NERDSpaceDelims = 1            " コメント記号の後にスペース追加
let g:NERDCompactSexyComs = 1        " コンパクトな構文を使用
let g:NERDDefaultAlign = 'left'      " 左寄せ
let g:NERDCommentEmptyLines = 1      " 空行もコメントアウト
let g:NERDTrimTrailingWhitespace = 1 " コメント解除時に末尾スペース削除
let g:NERDToggleCheckAllLines = 1    " トグル時に選択行全てチェック

" 十字キーオフの鬼畜プレイ
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>
" Leader キーをカンマに変更
let mapleader = ','

" ===== Vimターミナル設定 =====

" カスタムコマンド定義
" :T でターミナルを下部に高さ10行で開く（引数でコマンド実行可能 例: :T npm start）
command! -nargs=* T 10split | terminal <args>

" :VT でターミナルを右側に垂直分割で開く（引数でコマンド実行可能）
command! -nargs=* VT vsplit | terminal <args>

" ショートカットキー設定
" \t （バックスラッシュ+t）で下部に高さ10行のターミナルを開く
nnoremap <Leader>t :10split \| terminal<CR>

" \vt （バックスラッシュ+vt）で右側にターミナルを垂直分割で開く
nnoremap <Leader>vt :vertical terminal<CR>


" ターミナルモードでの操作
" Escキーを押すとターミナルモードからノーマルモードへ移行
" （ノーマルモードに戻ると、ターミナル内のテキストをコピーしたり検索できる）
tnoremap <Esc> <C-\><C-n>

" ターミナルモードのまま他のウィンドウへ移動
" Ctrl+h: ターミナルから左のウィンドウへ移動
tnoremap <C-h> <C-\><C-n><C-w>h

" Ctrl+j: ターミナルから下のウィンドウへ移動
tnoremap <C-j> <C-\><C-n><C-w>j

" Ctrl+k: ターミナルから上のウィンドウへ移動
tnoremap <C-k> <C-\><C-n><C-w>k

" Ctrl+l: ターミナルから右のウィンドウへ移動
tnoremap <C-l> <C-\><C-n><C-w>l


" 下部に高さ15行でGitステータスを開く
"command! GS botright Git | resize 15
" 上に高さ15行でGitステータスを開く
command! GS Git | resize 15

" :T で下部に高さ10行でターミナル
command! -nargs=* T 10split | terminal <args>

" Install vim-plug if it's not already installed (Unix-only).
if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()  " Manage plugins with vim-plug.

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-vinegar'
Plug 'preservim/nerdcommenter'
Plug 'cocopon/iceberg.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'haishanh/night-owl.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'tpope/vim-fugitive'

call plug#end()

set termguicolors
set background=dark

"colorscheme iceberg
"colorscheme night-owl
"colorscheme palenight
colorscheme catppuccin_mocha
