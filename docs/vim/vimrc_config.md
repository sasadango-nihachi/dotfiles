# Vim 設定（.vimrc）について

管理対象: `~/dotfiles/.vimrc` → `~/.vimrc`（シンボリックリンク）

使い方・キー操作は tank の `~/code/tank/library/vim/` を参照。ここは設定ファイルの中身の記録。

---

## 基本オプション

| 設定 | 内容 |
|---|---|
| `syntax on` / `filetype plugin indent on` | シンタックスハイライトとファイル種別ごとのインデント |
| `autoindent` / `expandtab` / `tabstop=4` / `shiftwidth=4` | 改行時にインデント継承、タブはスペース4つ（Python 前提） |
| `number` | 行番号。`relativenumber` はコメントアウトで残してある |
| `backspace=2` | 端末によっては backspace が効かないことへの対処 |
| `hlsearch` | 検索語をハイライト |
| `virtualedit=block` | 矩形選択で文字の無い位置も選べる |
| `wildmenu` / `wildmode=list:longest,full` | コマンドライン補完を「最長一致まで補完 → メニュー」に |
| `clipboard=unnamed` | ヤンクを OS のクリップボードと共有 |
| `termguicolors` / `background=dark` | 24bit カラーを有効化し暗色前提の配色に |

`packloadall` と `silent! helptags ALL` で、`pack/` 配下に置いたプラグインとその
ヘルプを起動時に読み込む（vim-plug とは別系統の標準機構）。

## ウィンドウ移動

`<C-w>` プレフィックスを省いて `Ctrl+h/j/k/l` だけで移動できるようにしている。

```vim
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
```

## Leader キー

```vim
let mapleader = ','
```

既定の `\` からカンマに変更。後述のターミナル系ショートカットがこれに乗る。

## ターミナル

Vim 8 以降の `:terminal` を使うためのカスタムコマンドとキー。

| 定義 | 動作 |
|---|---|
| `:T [cmd]` | 下部に高さ10行でターミナルを開く（引数でコマンド実行可） |
| `:VT [cmd]` | 右側に垂直分割でターミナルを開く |
| `<Leader>t` | 下部に高さ10行のターミナル |
| `<Leader>vt` | 右側に垂直ターミナル |

ターミナルモードからの脱出と移動:

```vim
tnoremap <Esc> <C-\><C-n>          " ノーマルモードへ（コピー・検索ができる）
tnoremap <C-h> <C-\><C-n><C-w>h    " ターミナルのまま左のウィンドウへ
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
```

`<C-\><C-n>` がターミナルモードを抜ける標準の打鍵。これを `<Esc>` と
ウィンドウ移動キーに割り当て、通常のバッファと同じ感覚で扱えるようにしている。

## Git（fugitive）

```vim
command! GS Git | resize 15
```

`:GS` で高さ15行の Git ステータス画面を開く。下部に出す版
（`botright Git | resize 15`）もコメントで残してある。

## プラグイン管理（vim-plug）

`~/.vim/autoload/plug.vim` が無ければ curl で取得し、`PlugInstall` を自動実行する
自己ブートストラップを入れてある。**別環境では `.vimrc` を置いて vim を起動するだけ**で
プラグインが揃う。

| プラグイン | 役割 |
|---|---|
| `ctrlpvim/ctrlp.vim` | ファイル・バッファのあいまい検索 |
| `scrooloose/nerdtree` | ファイルツリー（`NERDTreeToggle` 時に遅延ロード） |
| `tpope/vim-vinegar` | netrw を使いやすくする（`-` で親ディレクトリ） |
| `preservim/nerdcommenter` | コメントアウトのトグル |
| `tpope/vim-fugitive` | Git 操作 |
| `cocopon/iceberg.vim` / `drewtempelmeyer/palenight.vim` / `haishanh/night-owl.vim` / `catppuccin/vim` | 配色。現在は `catppuccin_mocha` を選択 |

## NERDTree

| 設定 | 内容 |
|---|---|
| `NERDTreeShowHidden=1` | ドットファイルを表示 |
| `NERDTreeShowBookmarks=1` | ブックマークを表示 |
| `NERDTreeAutoRefreshOnWrite=1` | 保存時にツリーを更新 |
| `g:NERDTreeChDirMode = 2` | ツリーでディレクトリを開くと Vim の作業ディレクトリも移動 |
| `:NT` | `NERDTree` の別名（自前の command 定義） |

`g:netrw_hide = 0` で netrw 側でも隠しファイルを出す。
`NERDTreeHijackNetrw` はコメントアウトで残してあり、vinegar と NERDTree の
どちらに寄せるかを切り替えられるようにしてある。

## NERDCommenter

コメント記号の後にスペースを入れる、空行もコメントアウトする、解除時に末尾スペースを
削除する、などを有効化している（`g:NERDSpaceDelims` / `g:NERDCommentEmptyLines` /
`g:NERDTrimTrailingWhitespace` ほか）。

## コメントアウトで残しているもの

意図的に無効化してあり、必要になったら外す。

- `relativenumber` — 相対行番号
- `foldmethod=indent` — インデントベースの折りたたみ
- `colorscheme murphy` / `blue` / `desert` — 配色の候補
- `autocmd VimEnter * NERDTree` — 起動時に自動でツリーを開く
- NERDTree だけが残ったら閉じる `autocmd`
- 十字キーを潰す `map <up> <nop>` 等

## 変更するときのメモ

- プラグインを足したら `call plug#begin()` 〜 `plug#end()` の間に `Plug` を追記して `:PlugInstall`
- 使い方の記録は tank の `library/vim/` に、設定の意図はこのファイルに
