# Neovim 設定（.config/nvim）について

管理対象: `~/dotfiles/.config/nvim` → `~/.config/nvim`（ディレクトリごとシンボリックリンク）

使い方・キー一覧は tank の `~/code/tank/library/hub/editor_hub.md`（hub）から辿る。ここは設定の中身の記録。

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

### Markdown: チェックボックス toggle（`<CR>`）と行内リンクを開く（`gx`）

tank の tech-daily 等が `- [ ] [title](url) — meta` の GFM チェックボックス箇条書きなので、
読みながらフラグを立てて開く操作を 1〜2 キーにした（`keymaps.lua` 末尾）。

- **`<CR>`（Enter）** … markdown バッファ限定・buffer-local。カーソル行の `[ ]`/`[?]` ⇄ `[x]` をトグル。
  ノーマルモードの Enter 既定（下行へ移動）はほぼ使わないので markdown だけ潰している。
- **`gx`** … 全ファイルタイプでグローバル上書き。カーソル行の最初の `http(s)` リンクをブラウザで開く。
  行に URL が無ければカーソル下の `<cfile>`（URL/実在パス）を開く＝標準 `gx` に近いフォールバック。

`gx` を「カーソル直下の URL」でなく **行から拾う** 方式にしたのは、render-markdown が URL を
conceal してカーソルを当てにくいため（列位置を問わず開ける）。plugin が独自 `gx` を持つバッファ
（oil / help 等）では buffer-local が優先されるので邪魔しない。

**取りこぼし対策**: `keymaps.lua` は LazyVim の VeryLazy で遅延ロードされる一方、起動時に開いた
ファイルの `FileType` はそれより前に発火する。そのままだと起動直後の markdown バッファに `<CR>`
が張られないので、`FileType` autocmd の登録に加えて「既に読み込み済みの markdown バッファへ即適用」
するループを併記している。

leader 版（`<leader>mx` / `<leader>mo`）もコメントで併記済み。切り替えたいときは各マップ行を入れ替える。

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
| `explorer.lua` | ファイルツリー（`<leader>e`）の調整。LazyVim 14 以降のツリーは neo-tree ではなく **snacks.picker の explorer ソース**。ドットファイルも gitignore 対象も表示し、重いものだけ個別に除外する。詳細は下記 |
| `git.lua` | LazyVim には gitsigns / lazygit が入っているが、`:Git` コマンドの資産のため fugitive も入れる（コマンド実行時に遅延ロード） |
| `lualine.lua` | statusline にリポジトリ全体の変更ファイル数を出す。詳細は下記 |
| `markdown.lua` | LazyVim の `lang.markdown` extra に被せる差分。render-markdown.nvim の anti-conceal（カーソル行だけ装飾を外して生の記法を見せる）が中核 |

### explorer の表示範囲（hidden / ignored / exclude）

3つの軸がある。`hidden` はドットファイル、`ignored` は gitignore 対象、
`exclude` はそのどちらとも独立に常に隠すグロブ。

```lua
hidden = true,    -- .claude/ .github/ .gitignore を触るので出す
ignored = true,   -- .tmp/ と finance/gdrive を出すために必要
exclude = { ".git", ".obsidian", "repo", ".playwright-cache",
            "__pycache__", ".DS_Store", "node_modules" },
```

`ignored` を既定の false にしていると、**`.tmp/`（作業場）と `finance/gdrive`
（Google Drive への symlink）がツリーから消える**。どちらも実際に開くので出している。

ただし true にするだけだと、tank が gitignore している重いものが並んでツリーが埋まる。
`shelf/code-reading/*/repo/`（解析対象のクローン本体・数千ファイル）と
`.claude/skills/tech-summary/.playwright-cache/`（約300MB）が特に効くので、
`exclude` で個別に落としている。

`exclude` は node のフルパスに対するグロブ照合（`Snacks.picker.util.globber`）で、
`"repo"` のような裸の名前でもディレクトリ名にマッチする。
`H`（hidden 切替）/ `I`（ignored 切替）とは別系統なので、押しても出てこない。

### 数式の表示（render-markdown.nvim + utftex）

markdown の `$...$` / `$$...$$` が **Unicode テキスト**として表示される。画像ではないので
端末を選ばず、フォントサイズを上げれば一緒に拡大する。

設定ファイルは無い。render-markdown.nvim の latex は**既定で有効**
（`enabled = true`, `converter = { 'utftex', 'latex2text' }`）で、
**変換コマンドが入っていなかったため黙って何もしていなかった**だけだった。

```bash
brew install utftex   # Brewfile に記録済み
```

これだけで有効になる。ブロック数式は多行の Unicode アートになる。

```
      ┌─────────────┐
      │  N
   ╲  │1 ⎲
σ=  ╲ │─ ⎳ (xᵢ - μ)²
     ╲│Nⁱ⁼¹
```

**mermaid とインライン SVG は端末では表示していない。** 端末の画像プロトコル
（Kitty/Sixel/iTerm2）はいずれもラスタで拡大ができず、wezterm は Unicode placeholders
未対応のため inline 描画も成立しない。図はブラウザ側（下記）で見る。
検証の全経緯は tank の `ideas/memo/20260829_nvim_markdown_mermaid_svg_brewfile.md`。

### ブラウザで見る（`<leader>cp` と `<leader>ch`）

図を含む markdown はブラウザで見る。2つあり役割が違う。

| キー | 実体 | 性質 |
|---|---|---|
| `<leader>cp` | markdown-preview.nvim（LazyVim の `lang.markdown` extra 付属） | サーバを立ててブラウザが接続。**編集にスクロール追従**。nvim の子プロセスとして常駐し、markdown 以外のバッファに移ると自動で閉じる |
| `<leader>ch` | tank の `scripts/md_to_html/`（`config/keymaps.lua` で定義） | **単一ファイルの HTML** を出して開く。サーバ不要・残る・人に渡せる |

`<leader>ch` はファイル種別で動作が変わる。

- **markdown** … HTML 化して `.tmp/` に出してから開く
- **html / svg** … そのまま開く（生成物の確認用）

**tank のスクリプトに依存している**点に注意。`~/code/tank/scripts/md_to_html/run.sh`
が無いと動かない（キーマップ側で存在チェックしてエラーを出す）。
変換の詳細・埋め込む資産の話は tank の `CLAUDE.md` を参照。

### lualine の変更ファイル数バッジ

LazyVim 標準の `lualine_x` にある `diff`（`+12 ~3 -1`）は
`vim.b.gitsigns_status_dict` が源で、**現在のバッファの行数**しか出ない。
gitsigns がグローバルに持つのは `g:gitsigns_head`（ブランチ名）だけで、
リポジトリ全体を集計する API は無い。そのため自前で `git status --porcelain` を数える。

描画のたびに git を起動すると重いので、値はキャッシュして
保存・フォーカス復帰・cwd 変更のときだけ非同期で更新する。
表示位置は `lualine_b` の branch の直後（「リポジトリ全体の話」だと分かる並び）。

Emacs 側にも同じバッジを入れてあり、そちらのハマりどころは
`~/code/tank/ideas/memo/202608/20260819_emacs_git_change_badge.md`。

### 補完の自動ポップアップを止めた（blink.cmp）

LazyVim 標準の補完エンジンは blink.cmp。既定は打鍵のたびに候補メニューが自動で開き、
インラインの薄い候補（ghost text）も出る。これが煩わしいので `plugins/completion.lua` で
自動表示だけ止めた（補完自体は残す）。

```lua
completion = {
  menu = { auto_show = false },     -- 打鍵中に自動でメニューを出さない
  ghost_text = { enabled = false }, -- インラインの薄い候補も出さない
}
```

- 補完が欲しいときは挿入モードで **`<C-Space>`** で手動表示。
- 完全に無効化（LSP 補完も出さない）なら opts を消して `enabled = false` だけにする。元に戻すなら `completion.lua` を削除。
- 出典は blink.cmp 側の docs（`completion.menu.auto_show` は同梱 `doc/recipes.md` に記載）。Neovim 本体の `:help` ではなくプラグインのドキュメント。

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
- 使い方の記録は tank の memo（`library/hub/editor_hub.md` から辿る）に、設定の意図はこのファイルに

## この設定が外部に依存しているもの

設定ファイルだけでは完結しない依存が3つある。別マシンで再現するときはここも要る。

| 依存 | 何のため | 入手 |
|---|---|---|
| `utftex` | markdown の数式を Unicode テキストで表示 | `Brewfile` に記録済み |
| `~/code/tank/scripts/md_to_html/` | `<leader>ch` の HTML 生成 | tank リポジトリ |
| Nerd Font（HackGen Console NF） | アイコン表示。`.wezterm.lua` の `font` と対 | `Brewfile` の cask |

`utftex` を消すと数式が素の LaTeX 表示に戻り、tank が無いと `<leader>ch` が
エラーを出す（どちらも他の機能には影響しない）。
