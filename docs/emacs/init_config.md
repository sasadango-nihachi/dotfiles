# Emacs 設定（init.el）について

管理対象: `~/dotfiles/.emacs.d/init.el` → `~/.emacs.d/init.el`（シンボリックリンク）

対象環境: GNU Emacs 30.2 (aarch64-apple-darwin, NS port) / macOS

キーバインドの学習メモは [emacs.md](./emacs.md) を参照。こちらは設定ファイルの中身の記録。

---

## キーバインド一覧

自分で割り当てたもの（`C-c <文字>` は Emacs の規約で利用者用に予約された領域）。

| キー | 動作 |
|---|---|
| `C-c t` | treemacs の開閉 |
| `C-c T` | treemacs へカーソル移動 |
| `C-c s` | ターミナル（eat）の開閉・フォーカス |
| `C-c g` | magit のステータス画面 |
| `C-c w` | サイドウィンドウ（treemacs + ターミナル）を一括開閉 |
| `C-c ← ↑ → ↓` | 上下左右のウィンドウへ移動 |
| `C-c u` / `C-c U` | ウィンドウ配置を元に戻す / やり直す |
| `C-c x` | 今のバッファを閉じる（VSCode の Ctrl+W 相当） |
| `C-c <tab>` / `C-c S-<tab>` | 次 / 前のエディタタブへ |

`C-c t` は「control を押しながら `c` → 離す → `t`」の順に押す（同時押しではない）。`C-c T` の最後は大文字なので `shift + t`。

キー表記の対応（macOS）: `C-` = control / `M-` = option（`ESC` 単独でも代用可）/ `S-` = shift / `s-` = command。`ns-alternate-modifier` が `meta` なので option が Meta として働く。

### treemacs のツリー内

最初に覚えるのは **`?`**（`treemacs-common-helpful-hydra`）。その場で主要キーの一覧が出る。`C-?` はさらに詳細版。以下は実際の `treemacs-mode-map` から抜き出したもの。

**移動**

| キー | 動作 |
|---|---|
| `n` / `p` | 1行下 / 上 |
| `M-n` / `M-p` | 同じ階層の次 / 前へ（兄弟ノード間をスキップ） |
| `u` | 親ディレクトリへ |
| `C-j` / `C-k` | 次 / 前のプロジェクトへ |
| `TAB` | ディレクトリの開閉 |
| `h` / `l` | 閉じる / 開く（vim 風） |
| `H` | 親ノードごと畳む |
| `S-TAB` | 全プロジェクトを畳む |
| `M-H` / `M-L` | ルートを1つ上 / 下へ |

**開く** — `o` プレフィックス

`RET` は今のウィンドウで開く。`global-tab-line-mode` を入れてあるので、開いたファイルは自動でタブとして並ぶ（＝「新規タブで開く」は `RET` だけで済む）。

| キー | 動作 |
|---|---|
| `RET` / `l` | 開く（タブが増える） |
| `o v` / `o h` | 縦分割 / 横分割して開く |
| `o o` | 分割せず既存ウィンドウで開く |
| `o c` | 開いて treemacs を閉じる |
| `o r` | 直近使ったウィンドウで開く |
| `o x` | 外部アプリで開く（macOS の `open`） |
| `o a a` / `o a v` / `o a h` | ace-window でウィンドウを選んでから開く |
| `P` | peek モード。カーソルを動かすだけで中身をプレビュー |

フレーム全体のタブ（tab-bar = 作業単位）で開きたい場合は treemacs ではなく `C-x t f`（`find-file-other-tab`）。tab-line がファイル単位、tab-bar が作業単位。

**ファイル操作**

| キー | 動作 |
|---|---|
| `c f` / `c d` | ファイル / ディレクトリを新規作成 |
| `R` / `m` / `d` | リネーム / 移動 / 削除 |
| `M-m` | 一括操作（複数選択してまとめて） |
| `y a` / `y r` / `y n` | 絶対パス / 相対パス / ファイル名をコピー |
| `!` / `M-!` | そのノード / プロジェクトルートでシェルコマンド実行 |
| `g` / `r` | ツリーを更新 |
| `s` | ソート順を変更 |
| `b` | ブックマーク登録（`C-x r b` で呼び出し） |

**表示トグル** — `t` プレフィックス

| キー | 動作 |
|---|---|
| `t h` | 隠しファイルの表示切り替え |
| `t i` | gitignore 対象を隠す |
| `t w` | 幅の固定を解除 |
| `t g` / `t f` / `t a` | git 表示 / follow モード / filewatch |
| `t n` / `t v` | インデントガイド / フリンジインジケータ |
| `w` / `<` / `>` / `=` | 幅を指定 / 縮める / 広げる / 内容に合わせる |
| `W` | 一時的に大幅に広げる（長いパス確認用） |

**その他**

| キー | 動作 |
|---|---|
| `q` | 閉じる（状態は保持される） |
| `Q` | バッファごと破棄 |
| `?` / `C-?` | ヘルプ（全キー一覧 / 詳細版） |

今開いているファイルの位置までツリーを展開したい場合は `M-x treemacs-find-file`。

**プロジェクト操作** — `C-c C-p` 配下

| キー | 動作 |
|---|---|
| `C-c C-p a` | プロジェクトを追加 |
| `C-c C-p d` | プロジェクトを削除（ツリーから外すだけ。ファイルは消えない） |
| `C-c C-p r` | 名前を変更 |
| `C-c C-p c c` | 今のプロジェクトを畳む |
| `C-c C-p c a` | 全プロジェクトを畳む |

**ワークスペース操作** — `C-c C-w` 配下。プロジェクトの集合を切り替える上位概念

| キー | 動作 |
|---|---|
| `C-c C-w a` | 作成 |
| `C-c C-w s` | 切り替え |
| `C-c C-w d` | 削除 |
| `C-c C-w r` | 名前変更 |
| `C-c C-w e` | 一覧をテキストで直接編集（まとめて編集できるので便利） |
| `C-c C-w n` | 次のワークスペースへ |

**登録の手っ取り早い方法**: 対象リポジトリのファイルを開いた状態で `M-x treemacs-add-and-display-current-project`。git リポジトリのルートを自動判定するのでパスを打たずに済む。

登録内容は `~/.emacs.d/.cache/treemacs-persist` に保存され次回起動時に復元される。init.el に書く必要はない。**このファイルは `elpa/` と同じく dotfiles には含まれない**ため、別環境では改めて登録する（環境ごとにパスが違うので妥当な挙動）。

### magit の中

| キー | 動作 |
|---|---|
| `n` / `p` | 次／前の行へ |
| `TAB` | 展開／折りたたみ（差分が見える） |
| `s` / `S` | ステージ（カーソル位置 / 変更のあるファイル全部） |
| `u` / `U` | アンステージ / 全部アンステージ |
| `k` | 変更を破棄（`magit-delete-thing`） |
| `x` | reset（`magit-reset-quickly`） |
| `c c` | コミット → メッセージ入力 → `C-c C-c` で確定（`C-c C-k` で中止） |
| `c a` | 直前のコミットを amend |
| `P p` | push（upstream へ） |
| `F p` | pull |
| `f` | fetch |
| `l l` | ログ |
| `d d` | diff |
| `b b` | ブランチ切り替え |
| `z` | stash |
| `y` | ref の一覧 |
| `!` | 任意の git コマンドを実行 |
| `$` | git の生の実行ログを見る |
| `g` | リフレッシュ |
| `?` | ヘルプ（全キー一覧） |
| `q` | 閉じる（バッファは裏に残る） |

`s` は**カーソル位置によって単位が変わる**。ファイル名の行なら1ファイル、`TAB` で展開して hunk 上なら塊単位、行を選択（`C-SPC` → 移動）してから押せば選んだ行だけ。

vim-fugitive は magit に影響を受けており、`s` / `u` / `cc` のキー体系はほぼ同じ。vim 側の操作感がそのまま使える。

### diff-hl（`C-x v` 配下）

diff-hl が有効なバッファでのみ生えるキー。

| キー | 動作 |
|---|---|
| `C-x v ]` / `C-x v [` | 次／前の変更箇所へジャンプ |
| `C-x v *` | その場で差分をポップアップ |
| `C-x v }` / `C-x v {` | 差分を見ながら次／前へ |
| `C-x v n` | その変更だけを取り消す（revert hunk） |
| `C-x v S` | その変更だけを stage する |

マーカーを目で探さなくても `C-x v ]` で変更箇所に飛べる。`C-x v S` は magit を開かずに部分ステージできる。

### エディタタブ（tab-line）

各ウィンドウの上端に、そこで開いたバッファがタブで並ぶ。VSCode の editor tabs 相当。

| 操作 | 動作 |
|---|---|
| タブの `✕` をクリック | そのバッファを閉じる（`kill-buffer`） |
| タブをクリック | 切り替え |
| `C-c <tab>` / `C-c S-<tab>` | 次 / 前のタブへ |
| `C-c x` | 今のバッファを閉じる |

treemacs と eat のサイドウィンドウにはタブを出さない設定にしてある。

### Markdown（gfm-mode）の中

`.md` は `gfm-mode` で開き、記法を隠した状態（プレビュー相当）で直接編集する。

| キー | 動作 |
|---|---|
| `C-c C-x C-m` | 記法の表示 / 非表示を切り替え |
| `C-c C-x C-i` | 画像のインライン表示を切り替え |
| `S-TAB` | 全体を 目次 → アウトライン → 全文 で循環 |
| `TAB` | カーソル位置の見出しを折りたたむ |
| `C-c C-n` / `C-c C-p` | 次 / 前の見出しへ |
| `C-c C-f` / `C-c C-b` | 同レベルの見出しへ |
| `C-c C-u` | 親見出しへ |
| `C-c C-o` | リンク・`[[wikilink]]` を開く |
| `M-p` / `M-n` | 次 / 前のリンクへ |
| `C-c C-d` | 文脈依存。チェックボックス切替・参照/脚注ジャンプ・表の整形 |
| `C-c C-l` / `C-c C-i` | リンク / 画像の挿入・編集 |
| `C-c C-s b` / `i` / `c` / `q` / `C` | 太字 / イタリック / インラインコード / 引用 / コードブロック |
| `C-c C-s t` / `[` / `f` / `-` | 表 / チェックボックス / 脚注 / 水平線 |
| `M-RET` | リストアイテムを追加（マーカーとインデントを自動判定） |
| `C-c '` | コードブロックを別バッファでその言語のモードで編集（要 `edit-indirect`） |
| `C-c C-c c` / `u` | 未定義の参照リンク / 未使用の参照定義を検出 |
| `C-c C-c n` | 順序付きリストの番号を振り直し |
| `C-c C-c l` | 分割プレビュー（別バッファに HTML を出す方式。通常は不要） |

**表の編集**（カーソルが表の中にある時）

| キー | 動作 |
|---|---|
| `TAB` / `S-TAB` | 次 / 前のセルへ。移動時に自動で整形し直す |
| `C-c ← → ↑ ↓` | 行・列の移動 |
| `C-c S-↑` / `S-↓` | 行の削除 / 挿入 |
| `C-c S-←` / `S-→` | 列の削除 / 挿入 |
| `C-c C-c ^` | 行のソート |
| `C-c C-c \|` | リージョンを表に変換 |
| `C-c C-c t` | 表の転置 |

長いメモを読む時は `S-TAB` で目次表示にしてから目的の見出しで `TAB`、が基本操作。

### eat（ターミナル）の中

| キー | 動作 |
|---|---|
| `C-c C-e` | semi-char モード（既定）と emacs モードの切り替え |
| `C-c C-k` | char モード。キー入力を全部端末側へ渡す |

TUI アプリ操作中に矢印キーや `C-c` が効かない場合は char モードにする。

### 標準のウィンドウ操作（参考）

| キー | 動作 |
|---|---|
| `C-x 2` / `C-x 3` | 上下 / 左右に分割 |
| `C-x 0` / `C-x 1` | 今のを閉じる / 他を全部閉じる |
| `C-x o` | 次のウィンドウへ（順送り） |
| `C-x +` | 大きさを揃える |

---

## なぜ init.el だけをリンクするのか

`~/.emacs.d/` にはリンクしてはいけないものが同居する。

| 中身 | 性質 |
|---|---|
| `init.el` | 設定。**バージョン管理したい** |
| `elpa/` | インストール済みパッケージ本体。環境ごとに再生成されるもの |
| `auto-save-list/` | 自動保存の作業ファイル |
| `eln-cache/` | ネイティブコンパイル済みキャッシュ |

`.claude` を丸ごとリンクしないのと同じ理由で、**`init.el` という個別ファイルだけ**をリンクする。

このため `install.sh` に `NESTED_FILES[]` という配列を追加した。`FILES[]`（ホーム直下）でも `CONFIG_DIRS[]`（`~/.config` 配下）でも扱えない「サブディレクトリ内の個別ファイル」を対象にする。

```bash
NESTED_FILES=(
    ".emacs.d/init.el"
)
```

リンク先の親ディレクトリは `mkdir -p "$HOME/$(dirname "$item")"` で先に作ってから `ln -s` する。

---

## 別環境での導入手順

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` が張るのは**シンボリックリンクだけ**。パッケージとフォントは init.el 側が起動時に自動で入れる（自己ブートストラップ）。つまり **install.sh 実行後に Emacs を1回起動すれば完了**する。

初回起動時に走る処理:

1. `my/required-packages` のうち未導入のものを MELPA から取得
2. Nerd Font が見つからなければ `nerd-icons-install-fonts` でダウンロード（GUI 起動時のみ）

初回はネットワーク越しのダウンロードが入るので起動に少し時間がかかる。2回目以降は `package-archive-contents` があるので refresh をスキップする。

### 検証済み

空の `HOME` を作ってそこから起動させたところ、パッケージが自動導入され、アイコン（`a.py` → U+E73C）まで解決することを確認済み。

---

## 設定の中身

### 1. パッケージ管理（自己ブートストラップ）

MELPA を追加し、`my/required-packages` の未導入分を起動時に自動インストールする。

| パッケージ | 役割 |
|---|---|
| `nerd-icons` | Nerd Font のアイコンライブラリ。以下すべての土台 |
| `doom-modeline` | モダンなモードライン |
| `nerd-icons-dired` | dired のファイル一覧にアイコン |
| `nerd-icons-completion` | 補完候補にアイコン |
| `treemacs` | ファイルツリーのサイドバー（VSCode の Explorer 相当） |
| `treemacs-nerd-icons` | treemacs のアイコンを nerd-icons に差し替えるテーマ |
| `magit` | git クライアント |
| `diff-hl` | 行左端に変更マーカー（VSCode の gutter 相当） |
| `treemacs-magit` | treemacs を magit の操作に追随させる |
| `eat` | 端末エミュレータ（NonGNU ELPA、ビルド不要） |
| `exec-path-from-shell` | ログインシェルから PATH を取り込む |

NonGNU ELPA は Emacs 30 の既定アーカイブに含まれている（`package-archives` の既定は `("gnu" "nongnu")`）ので、追加設定なしで `eat` が取得できる。明示的に足しているのは MELPA のみ。

インストール失敗時は `condition-case` で握り潰してメッセージだけ出す。1つのパッケージが取れなくても Emacs が起動不能にならないようにするため。

### 2. 起動時の挙動

- `inhibit-startup-screen` — スプラッシュ画面を消す
- `initial-scratch-message` — `*scratch*` 冒頭のコメントを消す

### 3. UI 部品の整理

```elisp
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
```

ツールバーの実体は `etc/themes` ではなく `<Emacs.app>/Contents/Resources/etc/images/` にある **66個の xpm/pbm ビットマップ**。90年代の素材なので nerd-icons のアイコンと並ぶと世代差が目立つ。VSCode 風の見た目にするなら消すのが筋。

スクロールバーも同様に古い見た目。位置情報はモードラインに `L1 All` として出るので実用上困らない。

`fboundp` で囲んでいるのは、これらの機能を持たないビルド（端末専用ビルド等）でエラーにしないため。

### 4. テーマ

Emacs 同梱の **`misterioso`** をベースに、**背景だけ黒系（`#0D0D0D`）へ上書き**している。追加パッケージ不要。

背景の上書きは `my/apply-peacock-chrome` の中で行う（`load-theme` への advice 経由で呼ばれるので、テーマ再読込でも維持されるため）。純黒 `#000000` はきついので少しだけ持ち上げてある。

```elisp
(load-theme 'misterioso t)
;; 背景は my/apply-peacock-chrome 側で上書き
(set-face-attribute 'default nil :background "#0D0D0D")
(set-face-attribute 'region  nil :background "#2d4948")   ; misterioso 由来を維持
(set-face-attribute 'hl-line nil :background "#1a1a1a" :inherit 'unspecified)
```

配色の3層構成:

```
エディタ本体   #0D0D0D   黒系
treemacs      #1A0A00   activityBar（わずかに暖色寄りなので境界がわかる）
モードライン   #8B0000   statusBar
```

misterioso のシンタックスは緑 `#74af68` / シアン `#00ede1` `#34cae2` に加えて**橙 `#ffad29` `#e67128`** を持つため、黒背景なら外枠の琥珀とも繋がる。misterioso 既定の背景 `#2d3743`（青灰）のままだと外枠の暖色から分離して見えるので上書きしている。

#### 検討して見送った案

**自作テーマ** — VSCode から持ってきた JSON は Peacock の設定なので、**エディタ本体の配色が含まれていない**（`activityBar` / `statusBar` / `titleBar` のみ）。同じ4色をシンタックスハイライトに使うと色相が赤〜橙に集中し、キーワード・文字列・コメントの区別がつかなくなる。

**ef-themes（`ef-autumn`）** — 一度導入したが、背景 `#0f0e06` に黄緑寄りの茶が乗ってくすんで見えたため除去した。参考までに、目標 `#1A0A00` との背景色の距離は ef-autumn `#0f0e06`（13.2）> ef-cherie `#190a0f`（15.0）> ef-melissa-dark `#352718`（46.3）>> misterioso 既定 `#2d3743`（82.9）だった。

#### 他のテーマに変えたい場合

同梱テーマは23個ある（`M-x customize-themes` で一覧）。modus-vivendi / modus-operandi は高可読・アクセシビリティ準拠、他に wombat、deeper-blue など。

`load-theme` の行を差し替えるだけでよい。**外枠の配色は advice で維持される**が、`default` の背景上書きも同時に効くので、テーマ本来の背景を使いたい場合は `my/apply-peacock-chrome` から該当行を外すこと。

### 5. アイコン

`Symbols Nerd Font Mono` を使う。**このフォントが無いとアイコンが全部豆腐（□）になる**。

`(display-graphic-p)` で GUI 判定してから `find-font` で有無を確認し、無ければ自動インストールする。端末起動時は `find-font` が使えないのでスキップする。

手動で入れ直す場合: `M-x nerd-icons-install-fonts`

### 6. ファイルツリー（treemacs）

VSCode の Explorer 相当。左に常駐するサイドバー。

| 設定 | 値 | 意味 |
|---|---|---|
| `treemacs-width` | 70 | 幅（デフォルトは 35） |
| `treemacs-show-hidden-files` | `t` | ドットファイルを表示する |
| `treemacs-width-is-initially-locked` | `nil` | 幅のロックを外す（既定は `t` でマウス変更不可） |
| `treemacs-follow-mode` | 有効 | 編集中のバッファをツリー側で自動追跡 |
| `treemacs-filewatch-mode` | 有効 | ファイルの増減を検知して自動更新 |
| `treemacs-git-mode` | `'simple` | git の状態でファイル名を色分け（git コマンドのみ使用） |

アイコンは `treemacs-nerd-icons` で nerd-icons に統一する（既定はビットマップ画像）。

#### 隠しファイルの扱い

`.claude/`（スキル定義・エージェント定義・`settings.json`）が実質の作業対象なので表示する。`.github/` `.obsidian/` `.gitignore` も同様。一時的に切り替えるならツリー内で `t h`。

ただし `.git` は中身が数千ファイルあってツリーが埋まるため、常に隠す。これは `treemacs-show-hidden-files` とは**別系統**で、`treemacs-ignored-file-predicates` に入れたものは `t h` でも出てこない「絶対に出さない」枠になる。

```elisp
(defun my/treemacs-ignore-git-dir (file _path)
  (string= file ".git"))
(add-to-list 'treemacs-ignored-file-predicates #'my/treemacs-ignore-git-dir)
```

**`setq` で置き換えないこと。** 既定値には `.` / `..` / ロックファイル / flycheck の一時ファイルを弾く述語（macOS では `.DS_Store` も）が入っているので、`add-to-list` で足す。

実際の適用結果（tank 直下）:

```
.claude .claudeignore .gitignore .gitmodules .obsidian .vscode .tmp   → 表示
.git .DS_Store . ..                                                   → 非表示
```

```elisp
(require 'treemacs-nerd-icons)
(treemacs-load-theme "nerd-icons")
```

#### キーバインドの注意

**treemacs 公式が薦める `C-x t ...` は tab-bar のプレフィックスと衝突する。** Emacs 標準で `C-x t` は `tab-prefix-map` に割り当たっており、以下が既に埋まっている。

```
C-x t 1 = tab-close-other    C-x t 2 = tab-new     C-x t 0 = tab-close
C-x t d = dired-other-tab    C-x t b = switch-to-buffer-other-tab
C-x t f = find-file-other-tab
```

そのため `C-c <文字>`（利用者用に予約された領域）へ逃がしている。

| キー | コマンド |
|---|---|
| `C-c t` | `treemacs`（開閉） |
| `C-c T` | `treemacs-select-window`（ツリーへカーソル移動） |

#### 幅の変え方とドラッグのハマりどころ

treemacs の既定は幅ロック（`treemacs-width-is-initially-locked` が `t`）で、マウスでは変更できない。`nil` にして解除してある。

ただし解除しても**掴む場所を間違えると効かない**。ドラッグの開始点がフリンジだと `<left-fringe> <drag-mouse-1>` という別イベントになり、`<left-fringe> <drag-mouse-1> is undefined` で終わる（treemacs が持っているのは `[drag-mouse-1]` だけ）。左フリンジは diff-hl のマーカー用に 16px へ広げてあるので特に当たりやすい。

掴むのは**ツリーと編集画面の間の境界線（window-divider）**の方。この線は `window-divider-default-right-width` が実質の当たり判定なので、1px のままではまず掴めない。4px にしてある。

キーで変える場合（こちらの方が確実）:

| キー | 動作 |
|---|---|
| `w` | 幅を数値で指定（`C-u 80 w` のように数引数でも可） |
| `>` / `<` | 広げる / 狭める |
| `=` | 中身の長さに合わせる |
| `W` | 一時的に大幅に広げるトグル（長いパス確認用） |
| `t w` | ロックのその場での切り替え |

#### 背景色の変え方

treemacs には「ウィンドウ全体の背景」を指すフェイスが無い。`treemacs-mode-hook` で **バッファローカルに `default` フェイスを差し替える**（`face-remap-add-relative`）方式を採っている。

```elisp
(add-hook 'treemacs-mode-hook
          (lambda ()
            (face-remap-add-relative 'default :background "#1A0A00")
            (face-remap-add-relative 'fringe  :background "#1A0A00")))
```

`#1A0A00` は VSCode 側の `activityBar.background` にあたる色。

### 7. 既定フォント

`HackGen Console NF`（v2.9.0、日本語対応かつ Nerd Font パッチ済み）を既定にしている。アイコン用フォントへフォールバックせずに描画されるため安定する。

```elisp
(let ((font "HackGen Console NF"))
  (when (and (display-graphic-p) (find-font (font-spec :name font)))
    (set-face-attribute 'default nil :family font :height 140)))
```

`find-font` で囲んでいるのは、このフォントが入っていない別マシンで既定フォントのまま素通りさせるため。**囲まないと、フォント名が違うだけで無言でスキップされる**ので注意（`set-face-attribute` は存在しないフォントを指定してもエラーにならない）。

ファミリー名は `HackGenConsoleNF-Regular.ttf` というファイル名ではなく **`HackGen Console NF`**。確認方法:

```bash
system_profiler SPFontsDataType | grep -i "family:.*hackgen" | sort -u
```

### 8. UI の配色（VSCode Peacock 相当）

VSCode の Peacock 拡張と同じ考え方で、**エディタ本体ではなく「外枠」だけを塗る**。エディタの配色はテーマ（misterioso）のまま残す。

パレット:

| 色 | 用途 | VSCode での対応 |
|---|---|---|
| `#8B0000` | モードライン背景・diff-hl の削除 | `statusBar.background` |
| `#E8A24A` | 前景（琥珀）・diff-hl の変更 | `statusBar.foreground` |
| `#B30000` | 変更数バッジの背景 | `activityBarBadge.background` |
| `#C17A30` | アクティブ・境界線・treemacs のディレクトリ名 | `activityBar.activeBackground` / `sash.hoverBorder` |
| `#1A0A00` | treemacs / タブバーの背景 | `activityBar.background` |
| `#5E0400` | 非アクティブ背景 | `titleBar.inactiveBackground` (`#8B000099`) |
| `#96652C` | 非アクティブ前景・treemacs のファイル名 | `activityBar.inactiveForeground` (`#E8A24A99`) |

diff-hl の変更マーカーもこのパレットに合わせている。

| フェイス | 色 | 意味 |
|---|---|---|
| `diff-hl-insert` | `#C17A30` | 追加行 |
| `diff-hl-change` | `#E8A24A` | 変更行 |
| `diff-hl-delete` | `#8B0000` | 削除 |

**アルファ値について**: Emacs のフェイスは透明度を持てない。VSCode 側の `#E8A24A99`（アルファ 0x99 = 60%）のような指定は、背景色 `#1A0A00` の上で**事前に合成した不透明色**に変換する必要がある。

**境界線の太さ**: `window-divider-default-right-width` は見た目の線の太さと**マウスの当たり判定を兼ねている**。VSCode の sash のように「細く見えるが掴む範囲は広い」という分離ができないため、ドラッグでウィンドウ幅を変えたいなら太くするしかない。4px にしてある（1px では実質掴めない）。細い線に戻す場合はマウスでのリサイズを諦めることになる。

```
#E8A24A を 60% で #1A0A00 に合成 → #96652C
#8B0000 を 60% で #1A0A00 に合成 → #5E0400
```

配色は `my/apply-peacock-chrome` 関数にまとめてあり、`load-theme` に `advice-add` で後掛けしている。**テーマを切り替えても外枠の配色が失われない**ようにするため（テーマ読み込みはフェイスをリセットするので、後から上書きし直す必要がある）。

#### 呼び出す位置に注意（ハマりどころ）

**`(my/apply-peacock-chrome)` の実行は init.el の末尾**に置いてある。この関数は treemacs や diff-hl のフェイスも触るため、それらを `require` する前に呼ぶと `(when (facep 'diff-hl-insert) ...)` のガードに阻まれ、**エラーも警告も出さずに静かに無視される**。

実際に diff-hl 導入時にこれを踏んだ。確認方法:

```elisp
(face-attribute 'diff-hl-insert :background nil t)
;; => unspecified なら適用されていない
```

パッケージを増やして新しいフェイスを足す場合も、`require` より後に適用されるようこの順序を保つこと。

対応関係:

- **activityBar** — 当初は相当する常設 UI が無かったためタブバーに割り当てていたが、treemacs 導入後はそのサイドバーが実質の受け皿になっている（`#1A0A00`）
- **activityBarBadge** — Emacs にバッジの概念は無いが、モードラインと treemacs のプロジェクト行に自前で実装した（Git の項を参照）
- **エディタ本体** — Peacock は VSCode でも外枠しか塗らないため、ここはテーマ（misterioso）のまま。VSCode 側の JSON にもエディタ配色は含まれていない

### 9. PATH の取り込み（exec-path-from-shell）

**macOS では Dock / Finder から起動したアプリはシェルの PATH を引き継がない。** launchd の最小 PATH になるため、homebrew 等に入れたコマンド（`claude`、`git`、`python` …）が Emacs から見つからない。

実測すると GUI 起動相当の環境ではこうなる。

```
PATH = :/Applications/Emacs.app/Contents/MacOS/bin-arm64-11:...
(executable-find "claude") => nil     ; 実体は /opt/homebrew/bin/claude
```

```elisp
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
```

**取り込むのは `PATH` と `MANPATH` のみ**（`exec-path-from-shell-variables` の既定値）。API キー等の秘匿値は対象外。ログインシェルは `("-l" "-i")` で起動される。

端末から起動した場合は既に PATH が通っているので、GUI 起動時のみ実行するようガードしている。

**確認方法**:

```elisp
(getenv "PATH")
(executable-find "claude")   ; nil なら通っていない
```

### 10. ターミナル（eat）

VSCode の統合ターミナル相当。`C-c s` で下部の side window に開く。

#### eshell / shell では TUI アプリが動かない

**これが eat を入れた理由。** `eshell` と `M-x shell` は comint ベースの**行指向**インターフェースで、端末エミュレータではない。カーソル移動や ANSI エスケープを解釈する PTY を持たないため、画面全体を描き換えるアプリ（claude、vim、top、htop 等）は動かない。

| 方式 | TUI アプリ | 備考 |
|---|---|---|
| `eshell` / `M-x shell` | ✗ | 行指向。git やファイル操作には十分 |
| `M-x ansi-term` | △ | 端末エミュレーションはあるが遅い |
| **`eat`** | ○ | **純 elisp、ビルド不要。採用** |
| vterm | ○ | 最速だが C モジュールのビルドに cmake が必要 |

なお eshell かどうかは起動時のバナー `Welcome to the Emacs shell`（`eshell-banner-message` の既定値）で判別できる。eat では出ない。

#### side window での表示

```elisp
(setq display-buffer-alist
      (append display-buffer-alist
              '(("\\`\\*\\(?:.*-\\)?eat\\*\\(?:<[0-9]+>\\)?\\'\\|\\`\\*e?shell\\*\\'"
                 (display-buffer-in-side-window)
                 (side . bottom)          ; 'top / 'left / 'right に変更可
                 (slot . 0)
                 (window-height . 0.3)    ; フレーム高さの30%
                 (window-parameters
                  (no-delete-other-windows . t))))))
```

`no-delete-other-windows` を付けると `C-x 1` でも消えない（VSCode のパネルと同じ挙動）。左は treemacs が使っているので下に出している。

正規表現は `*eat*` / `*eat*<2>` / `*tank-eat*`（`eat-project` は `project-prefixed-buffer-name` を使う）/ `*eshell*` / `*shell*` にマッチし、`*scratch*` `*Messages*` には誤爆しないことを確認済み。

`C-c s` は VSCode の Ctrl+` と同じ3状態にしてある（閉じている→開いて移動 / 開いている→移動 / フォーカス中→閉じる）。

### 11. ウィンドウ間の移動

```elisp
(require 'windmove)
(global-set-key (kbd "C-c <left>")  #'windmove-left)
;; … right / up / down も同様

(setq winner-dont-bind-my-keys t)
(winner-mode 1)
(global-set-key (kbd "C-c u") #'winner-undo)
(global-set-key (kbd "C-c U") #'winner-redo)
```

どちらも Emacs 同梱。ハマりどころが3つある。

**1. `S-<arrow>` を使うとシフト選択が死ぬ** — windmove の既定は `S-<arrow>` だが、これは**シフト+矢印の範囲選択**と衝突する。`S-<left>` は明示的な割り当てを持たず（`key-binding` は `nil` を返す）、shift-translation という別機構で選択に使われているため、明示的に上書きすると選択側が動かなくなる。完全に空いている `C-c <arrow>` を使っている。

**2. `windmove-default-keybindings` にプレフィックスは渡せない** — 受け付けるのは `shift` / `meta` / `control` などの修飾キーのみ。`C-c` を渡すと `Two bases given in one event` で起動時にエラーになる。個別に `global-set-key` する。

**3. winner-mode は既定で `C-c <left>` / `C-c <right>` を奪う** — windmove と正面衝突するので `winner-dont-bind-my-keys` を `t` にしてから有効化する。

矢印キーの衝突状況（実測）:

| キー | 既定の割り当て |
|---|---|
| `S-<arrow>` | なし（ただしシフト選択が使用） |
| `M-<left>` / `M-<right>` | `left-word` / `right-word` |
| `C-<left>` / `C-<up>` | `left-word` / `backward-paragraph` |
| `s-<left>` | `move-beginning-of-line` |
| **`C-c <arrow>`** | **空き** |

### 12. Git（magit + diff-hl）

```elisp
(require 'magit)
(global-set-key (kbd "C-c g") #'magit-status)
(require 'treemacs-magit)

(require 'diff-hl)
(global-diff-hl-mode 1)
(diff-hl-flydiff-mode 1)              ; 保存前の編集中も差分を反映する
(add-hook 'dired-mode-hook #'diff-hl-dired-mode)

;; magit で stage/commit した直後にマーカーを更新する
(add-hook 'magit-pre-refresh-hook  #'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
```

`diff-hl-flydiff-mode` を入れているので**保存前でもマーカーが出る**（既定は保存後のみ）。VSCode と同じ挙動にするための指定。

git の状態表示は4層に分かれている。

| 層 | 担当 |
|---|---|
| サイドバーのファイル名の色分け | `treemacs-git-mode`（treemacs 側で設定済み） |
| 開いているファイルの行マーカー | `diff-hl` |
| 変更ファイル数のバッジ | 自前実装（後述） |
| stage / commit / log などの操作 | `magit` |

#### フリンジ（マーカーの表示場所）

diff-hl のマーカーは**フリンジ**（テキスト領域の外側の細い帯）に描かれる。既定の 8px では細くて見えないので左を広げてある。

```elisp
(fringe-mode '(16 . 8))   ; 左16px / 右8px
```

フリンジはテーマ既定だと灰色の帯が浮くので、`my/apply-peacock-chrome` で `default` を継承させて馴染ませている。

**フリンジは「何か描かれた時だけ見える」領域**なので、帯そのものが見えないのは正常。マーカーが出るのは git 管理下かつ変更のあるファイルのみ。端末（GUI でない Emacs）ではフリンジが存在しないため、その場合は `diff-hl-margin-mode` に切り替えると行の左に記号で出る。

#### 変更ファイル数のバッジ（VSCode の activityBarBadge 相当）

VSCode の Source Control アイコンに出る数字（`29` など）に相当するもの。Emacs にアクティビティバーは無いので、2か所に出している。

| 場所 | 実装 |
|---|---|
| モードライン | `global-mode-string` に `:eval` を追加。doom-modeline が `misc-info` セグメントとして描画する |
| treemacs のプロジェクト行 | `treemacs-set-annotation-suffix`（lsp-treemacs が診断件数の表示に使っている API） |

数え方は `git status --porcelain` の行数。**未追跡ファイルも含む**ので VSCode の Source Control バッジと同じ基準になる。

**コスト対策**: `git status` を再描画のたびに走らせると重いので、ハッシュにキャッシュして以下のタイミングでのみ更新する。

| きっかけ | モードライン | treemacs |
|---|---|---|
| ファイル保存 | 更新 | 更新 |
| ファイルを開く | 更新 | — |
| magit の更新後 | 更新 | 更新 |
| treemacs の描画後・選択時・更新後 | — | 更新 |

ファイルを開くたびに全プロジェクトを数え直すのは無駄なので、treemacs 側は外してある。登録プロジェクトが増えると保存のたびにプロジェクト数だけ `git status` が走るので、重く感じたら `after-save-hook` から treemacs 側を外して magit 更新時だけにする。

**モードラインを丸ごと再定義していない理由**: doom-modeline の `main` 定義を書き換えるより `global-mode-string` に足すほうが、doom-modeline 側の更新で壊れにくい。`misc-info` は `main` の右側セグメントに含まれている（`compilation objed-state misc-info project-name ...`）ので、位置は右端ではなく `major-mode` や `vcs` より左になる。

#### treemacs-mode-hook は使えない（ハマりどころ）

treemacs 側のバッジを `treemacs-mode-hook` に登録すると**動かない**。このフックはメジャーモード設定時、つまり**ツリーが描画される前**に走るため、アノテーションを付ける対象のノードがまだ存在せず空振りする。

正しくは以下の3つ。

```elisp
(add-hook 'treemacs-post-buffer-init-hook #'my/treemacs-update-git-badges) ; 初回描画後
(add-hook 'treemacs-select-hook           #'my/treemacs-update-git-badges) ; ツリーに移った時
(add-hook 'treemacs-post-refresh-hook     #'my/treemacs-update-git-badges) ; 更新後
```

`treemacs-post-refresh-hook` は**引数付きで呼ばれる**ので、関数側は `(&rest _)` を取る必要がある。

デバッグ用に `interactive` を付けてあるので `M-x my/treemacs-update-git-badges` で手動実行できる。

#### バッチモードでは検証できないもの

`format-mode-line` は `--batch` では**素の文字列を渡しても `""` を返す**。モードラインへの描画は GUI でしか確認できないので、バッチでの検証はバッジ関数の戻り値までに留まる。

| キー | 動作 |
|---|---|
| `C-c g` | magit のステータス画面 |
| magit 内 `s` / `u` | stage / unstage |
| magit 内 `c c` | コミット（`C-c C-c` で確定） |
| magit 内 `?` | ヘルプ（全キー一覧） |

### 13. tree-sitter（構文解析ベースのハイライト）

`*-ts-mode` は Emacs 30 に**同梱されている**（rust / typescript / tsx / python / json / yaml / toml / go / c / java / ruby / php / lua / dockerfile / cmake / html / elixir 等）。同梱されていないのは terraform と markdown くらい。

同梱されていないのは**言語ごとの「文法」**のほうで、これは別途ビルドが要る。`cc` と `git` があればよく、`~/.emacs.d/tree-sitter/*.dylib` に置かれる。

```
M-x treesit-install-language-grammar RET <言語> RET
```

#### バージョン固定は必須（ハマりどころ）

**`treesit-language-source-alist` のバージョンは必ず固定すること。**

各文法の `master` は tree-sitter 0.25 系（**ABI 15**）に移行済みだが、**Emacs 30.2 が読めるのは ABI 13〜14**。確認方法:

```elisp
(treesit-library-abi-version)     ;; => 14  （最大）
(treesit-library-abi-version t)   ;; => 13  （最小）
```

厄介なのは失敗の出方で、**ビルド自体は成功して `.dylib` も生成されるのに、読み込み時に無効化される**。

```
Warning (treesit): The installed language grammar for python cannot be located
or has problems (version-mismatch): 15
```

そのため ABI 14 世代のタグに固定してある。

| 言語 | 固定バージョン |
|---|---|
| rust | v0.23.3 |
| typescript / tsx | v0.23.2 |
| python | v0.23.6 |
| json | v0.24.8 |
| yaml | v0.5.0（ikatyang） |
| toml | v0.5.1 |
| bash | v0.23.3 |

固定していない状態では rust / python / bash が version-mismatch で失敗し、他の5言語はたまたま通っただけだった。**通った言語も master が上がれば同様に壊れる**ので、全部固定してある。

Emacs 側を新しくして ABI 15 に対応した場合は、タグを上げ直せばよい。

#### モードの割り当て

```elisp
;; 既存のメジャーモードを ts 版に読み替える
(setq major-mode-remap-alist
      '((python-mode    . python-ts-mode)
        (js-json-mode   . json-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (sh-mode        . bash-ts-mode)))

;; 旧モードが同梱されていない拡張子は自分で紐づける
(dolist (entry '(("\\.rs\\'"    . rust-ts-mode)
                 ("\\.ts\\'"    . typescript-ts-mode)
                 ("\\.tsx\\'"   . tsx-ts-mode)
                 ("\\.ya?ml\\'" . yaml-ts-mode)))
  (add-to-list 'auto-mode-alist entry))
```

`.rs` `.ts` は旧モードが同梱されていないため `auto-mode-alist` への追加が必要（`major-mode-remap-alist` は「既存モードの読み替え」なので効かない）。

なお **tree-sitter を入れなくてもシンタックスハイライトは効いている**（`font-lock-mode` が標準で有効）。tree-sitter は精度を上げるもので、有無で色が付く／付かないが変わるわけではない。

### 14. macOS のタイトルバー

macOS のタイトルバーは OS 側の描画なので任意色にできない。`ns-transparent-titlebar` で透過させ、フレーム背景と一体化させる方式を採る（Emacs 26 で導入された NS ポートのフレームパラメータ）。

```elisp
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
```

### 15. エディタタブ（tab-line）

init.el 上の位置は treemacs と「UI の配色」の間。

**`tab-bar` と `tab-line` は別物。**

| | 単位 | VSCode で言うと |
|---|---|---|
| `tab-bar` | フレーム全体。ウィンドウ配置ごと切り替える | ウィンドウ / ワークスペース |
| `tab-line` | 各ウィンドウの上端。そこで開いたバッファが並ぶ | エディタタブ |

「開いているファイルに ✕ ボタンが付いたタブ」が欲しい場合は後者。Emacs 27 から同梱で、✕ ボタンも標準で付く。

```elisp
(require 'tab-line)

(setq tab-line-close-button-show t
      tab-line-new-button-show nil
      tab-line-separator " "
      tab-line-close-tab-function #'kill-buffer)

(dolist (mode '(treemacs-mode eat-mode))
  (add-to-list 'tab-line-exclude-modes mode))

(global-tab-line-mode 1)
```

`tab-line-close-tab-function` の既定は `bury-buffer` で、**✕ を押してもタブから消えるだけでバッファは残る**。VSCode の ✕ と同じ挙動にするため `kill-buffer` に変えている。

サイドウィンドウ（treemacs / eat）にタブが出ると邪魔なので `tab-line-exclude-modes` に足す。既定は `(completion-list-mode)` のみ。

配色は `my/apply-peacock-chrome` 側で `tab-line` / `tab-line-tab` / `tab-line-tab-current` / `tab-line-tab-inactive` / `tab-line-highlight` に指定する。**アクティブなタブだけエディタ本体と同じ `#0D0D0D`** にして地続きに見せ、非アクティブは activityBar と同じ `#1A0A00` に落としている。

### 16. Markdown（プレビュー状態のまま編集する）

init.el 上の位置は tree-sitter と macOS タイトルバーの間。

VSCode は「ソース」と「プレビュー」を別ペインに並べる方式で、プレビュー側は生成された HTML なので編集できない。`markdown-mode` の `markdown-hide-markup` は方式が違い、**別バッファを作らずファイルを開いているバッファ自体に `invisible` / `display` のテキストプロパティを被せて記法を隠す**。見えているものが実ファイルそのものなので、そのまま編集できる。Obsidian の Live Preview と同じモデル。

実際の見え方（tank のメモを読ませて検証）:

```
元ファイル                              Emacs 上の表示
# GTD と org-mode                   →   GTD と org-mode         （2倍サイズ）
**Getting Things Done**             →   Getting Things Done     （太字表示）
- 2分以内で終わる                    →   ● 2分以内で終わる
---                                 →   ────────────────────
`markdown-hide-markup`              →   markdown-hide-markup
```

表はそのまま残る。

```elisp
(require 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))

(setq-default markdown-hide-markup t)
(customize-set-variable 'markdown-header-scaling t)

(setq markdown-fontify-code-blocks-natively t
      markdown-enable-wiki-links t
      markdown-wiki-link-fontify-missing t)

(add-hook 'markdown-mode-hook #'visual-line-mode)
```

#### ハマりどころ1: `setq` では効かない

`markdown-hide-markup` は `make-variable-buffer-local` されている。素の `setq` は `*scratch*` だけに効いてグローバルの既定値（`nil`）が変わらないため、md を開いても**何も隠れない**。`setq-default` が要る。

`markdown-header-scaling` の方は逆に `:set` で `markdown-update-header-faces` を呼んでフェイスの `:height` を書き換える defcustom なので、`setq` だと `:set` が走らず**見出しの大きさが変わらない**。`customize-set-variable` を使う。

#### ハマりどころ2: `.md` は `gfm-mode` で開かないと壊れる

素の `markdown-mode` は語中の `_` もイタリック記法と解釈する。記法を隠すと wikilink が崩れる。

```
[[20260813_orgmode_usage_patterns]]  →  20260813orgmodeusagepatterns
```

GFM は語中の `_` を強調と見なさない仕様で、`gfm-mode` がそれを実装している（`markdown--gfm-markup-underscore-p`）。tank のファイル名は全部 `_` 区切りなので `.md` → `gfm-mode` は必須。

ついでに `gfm-mode` は `markdown-wiki-link-search-subdirectories` を `t` にするので、ファイルが月別フォルダへ移動しても `[[...]]` が追える。

#### 入れなかったもの

- **`variable-pitch-mode`**（プロポーショナルフォント）— 表の桁揃えは文字数ベースなので等幅でないと崩れる。メモは表が多い。`HackGen Console NF` は全角＝半角2つ分の幅で描画されるため、等幅のままなら日本語混じりの表も揃う
- **カーソル行での記法復帰** — Obsidian は編集中の行だけ `**` が現れるが、markdown-mode は全体一括のトグル（`C-c C-x C-m`）しかない。org には `org-appear` があるが markdown 版は見つからなかった。`**` の境界が見えないまま消す事故が起きたら一時的にトグルで戻す

---

## 変更するときのメモ

- **色を確認したい**: `M-x list-faces-display` で定義済みフェイスを実際の見た目付きで一覧、`M-x customize-face` で個別編集
- **`customize-face` で保存すると** `custom-set-faces` ブロックに書き込まれ、手書きの `set-face-attribute` と混ざって分かりにくくなる。どちらかに寄せること（現状は手書きに統一）
- **テーマを変える**: `load-theme` の行を差し替えるだけ。外枠の配色は advice で維持される
- **パッケージを増やす**: `my/required-packages` に追記すれば次回起動時に自動で入る。新しいフェイスに色を付ける場合は `my/apply-peacock-chrome` に足す（適用は末尾で行われるので順序は気にしなくてよい）
- **treemacs の幅を変える**: 恒久的に変えるなら `treemacs-width` を書き換える。マウスでのドラッグも可（`treemacs-width-is-initially-locked` を `nil` にしてある）。キーで変えるならツリー内で `w`（数値指定）/ `>` / `<` / `=`
- **tree-sitter の言語を足す**: `treesit-language-source-alist` に追記して `M-x treesit-install-language-grammar`。**バージョンを固定すること**（ABI の項を参照）
- **treemacs に出したくないものを増やす**: `treemacs-ignored-file-predicates` に `add-to-list` で述語を足す（`setq` で潰さない）。ドットファイル全体の表示は `treemacs-show-hidden-files`、個別の恒久除外はこちら、と役割が違う
- **markdown 系の変数を足す**: バッファローカルかどうかを `C-h v` で確認してから書く。`(buffer-local)` と出るものは `setq-default`、`:set` を持つ defcustom は `customize-set-variable`、それ以外は `setq`。素の `setq` で書いて「効かない」となるのはだいたいこれ
- **バッチモードで見え方を検証する**: `emacs --batch -l init.el` に、バッファへ font-lock を適用してから `invisible` / `display` プロパティを解釈してテキストを組み直すスクリプトを渡すと、GUI を開かずに「画面に何が見えるか」を確認できる（記法が隠れているか、wikilink が壊れていないか等）
