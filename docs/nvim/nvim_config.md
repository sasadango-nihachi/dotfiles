# Neovim 設定（.config/nvim）について

管理対象: `~/dotfiles/.config/nvim` → `~/.config/nvim`（ディレクトリごとシンボリックリンク）

使い方・キー一覧は tank の `~/code/tank/library/neovim/` を参照。ここは設定の中身の記録。

ベースは **LazyVim**。「LazyVim のデフォルトを上書きしたいものだけ書く」方針で、
素の Neovim 設定を一から積む形にはしていない。

---

## 構成

```
.config/nvim/
├── init.lua                    -- config.lazy を読むだけ
├── lazyvim.json                -- LazyVim が管理する extras の記録
├── lazy-lock.json              -- プラグインのバージョン固定
└── lua/
    ├── config/
    │   ├── lazy.lua            -- lazy.nvim のブートストラップと spec
    │   ├── options.lua         -- LazyVim 起動「前」に読まれる
    │   ├── keymaps.lua         -- LazyVim 起動「前」に読まれる
    │   └── autocmds.lua        -- LazyVim 標準の autocmds の「後」に読まれる
    └── plugins/                -- 自前のプラグイン定義（lazy.nvim の spec）
        ├── colorscheme.lua
        ├── explorer.lua
        ├── git.lua
        ├── lualine.lua
        └── markdown.lua
```

読み込み順が挙動を左右する。`autocmds.lua` は **LazyVim の後**に走るので、
LazyVim の autocmd を上書きしたい場合はここに書く。プラグインの `init` に書くと
LazyVim より先に走って後から潰される。

## lazy.lua

lazy.nvim が無ければ git clone する公式のブートストラップ入り。**別環境では
`nvim` を起動するだけ**でプラグインが揃う。

有効にしている LazyVim Extras:

| extra | 内容 |
|---|---|
| `lang.python` | |
| `lang.rust` | |
| `lang.terraform` | |
| `lang.docker` | |
| `lang.markdown` | render-markdown.nvim（インライン装飾）+ marksman（LSP）+ markdownlint |

`performance.rtp.disabled_plugins` で標準プラグインを切っているが、
**`tutor` は `:Tutor` を使うのでコメントアウトして有効のまま**にしてある。

## options.lua

`.vimrc` から引き継いだもの（`tabstop=4` / `expandtab` / `hlsearch` /
`wildmode` / `virtualedit=block` / `termguicolors`）と、LazyVim 既定だが
明示しておくもの（`number` / `relativenumber` / `clipboard=unnamedplus`）。

### exrc（リポジトリ固有の設定）

```lua
opt.exrc = true
```

カレントディレクトリの `.nvim.lua` / `.nvimrc` / `.exrc` を読み込む
（VSCode の `.vscode/settings.json` 相当）。例: `~/code/tank/.nvim.lua` で
Peacock と同じ色をステータスラインに当てる。

**任意の Lua が実行されるので、clone してきた他人のリポジトリでは危険。**
Neovim は初回読み込み時に信頼を確認し、結果を `~/.local/state/nvim/trust` に
ハッシュ付きで記録する。内容が変わると再確認が入る。手動管理は
`:trust` / `:trust deny` / `:trust remove`。

## keymaps.lua

Leader は **LazyVim 標準の `<Space>`**。`.vimrc` は `,` だが、LazyVim の
公式ドキュメントとチュートリアルが全て `<Space>` 前提なのでそちらに合わせた。

### ウィンドウサイズ調整を `<leader>w` 配下に逃がした理由

LazyVim 標準は `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>` だが、
**macOS がこの4つを全部握っている**ため nvim まで届かない。

| キー | macOS 側の割当 |
|---|---|
| `Ctrl+←` / `Ctrl+→` | 操作スペース（デスクトップ）の移動 |
| `Ctrl+↑` | Mission Control |
| `Ctrl+↓` | アプリケーションウインドウ（App Exposé） |

システム設定で解放すれば標準キーも使えるが、デスクトップ切り替えを失う。
macOS 側を触らずに済むよう `<leader>w>` `<leader>w<` `<leader>w+` `<leader>w-` を足した。
標準の割当は残してあるので、将来 macOS 側を解放すれば両方使える。

### .vimrc から移植したもの

- `:T` / `:VT` — 下部 / 右側にターミナルを開くカスタムコマンド
- ターミナルモードからの `<Esc>` と `<C-h/j/k/l>` によるペイン移動
- `:GS` — Git status を高さ15行で開く（fugitive）

### :TutorJa

`:Tutor` はシェルロケール（`v:lang`）を見て言語を決めるため、英語ロケールでは
英語版が開く。ロケール非依存に日本語版を開くラッパー。`:TutorJa 2` で2章。

## autocmds.lua

### Markdown の赤い波線を止める

波線の出どころは LazyVim の `wrap_spell` autocmd（markdown / text / gitcommit で
`spell = true`）。波線には2種類あり原因が違う。

| 出る場所 | 原因 | 対処 |
|---|---|---|
| 日本語 | `spelllang` が en だけなので全部 SpellBad | `cjk` を足すと東アジアの文字が判定から外れる |
| 英単語 | 辞書に無い語（実測: md / mdt / nvim / wikilink / gitignore は SpellBad、brew / Markdown は出ない） | 語を足しても切りが無い |

tank のメモは技術語が本文の主役なので、**markdown / text では spell 自体を切る**。
gitcommit は英語の散文を書く場所なので spell を残し、日本語向けに `cjk` だけ足す。

個別に許容したい場合はその語の上で `zg`（`~/.config/nvim/spell/` の個人辞書に追加）。
`zw` で除外、`z=` で候補表示。

## plugins/

| ファイル | 内容 |
|---|---|
| `colorscheme.lua` | `.vimrc` と同じ catppuccin mocha |
| `explorer.lua` | ファイルツリー（`<leader>e`）の調整。LazyVim 14 以降のツリーは neo-tree ではなく **snacks.picker の explorer ソース**。tank は `.claude/` が実質の作業対象なのでドットファイルを最初から表示する |
| `git.lua` | LazyVim には gitsigns / lazygit が入っているが、`:Git` コマンドの資産のため fugitive も入れる（コマンド実行時に遅延ロード） |
| `lualine.lua` | statusline にリポジトリ全体の変更ファイル数を出す。詳細は下記 |
| `markdown.lua` | LazyVim の `lang.markdown` extra に被せる差分。render-markdown.nvim の anti-conceal（カーソル行だけ装飾を外して生の記法を見せる）が中核 |

### lualine の変更ファイル数バッジ

LazyVim 標準の `lualine_x` にある `diff`（`+12 ~3 -1`）は
`vim.b.gitsigns_status_dict` が源で、**現在のバッファの行数**しか出ない。
gitsigns がグローバルに持つのは `g:gitsigns_head`（ブランチ名）だけで、
リポジトリ全体を集計する API は無い。そのため自前で `git status --porcelain` を数える。

描画のたびに git を起動すると重いので、値はキャッシュして
保存・フォーカス復帰・cwd 変更のときだけ非同期で更新する。
表示位置は `lualine_b` の branch の直後（「リポジトリ全体の話」だと分かる並び）。

Emacs 側にも同じバッジを入れてあり、そちらのハマりどころは
`~/code/tank/library/emacs/git-change-badge.md`。

## nvim-bare（実験用の最小構成）

`~/.config/nvim-bare/init.lua`（63行）。プラグインも LazyVim も無い素の Neovim。
「この挙動は LazyVim のせいか、Neovim 本体か」を切り分けるための実験室。

```bash
NVIM_APPNAME=nvim-bare nvim    # alias: nvb
```

`NVIM_APPNAME` は Neovim が設定ディレクトリ名を切り替える環境変数。
`~/.config/<name>` と `~/.local/share/<name>` が別々に使われるので、
本番の設定・プラグインを一切汚さずに試せる。

## 変更するときのメモ

- LazyVim の Extras を足すときは `config/lazy.lua` の `spec` に `import` を追記
- LazyVim のデフォルトを**上書き**したい autocmd は `config/autocmds.lua` に書く（`init` では潰される）
- プラグインのバージョンは `lazy-lock.json` で固定される。`:Lazy update` 後はこれもコミットする
- 使い方の記録は tank の `library/neovim/` に、設定の意図はこのファイルに
