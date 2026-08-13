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
| `C-c g` | magit のステータス画面 |

`C-c t` は「control を押しながら `c` → 離す → `t`」の順に押す（同時押しではない）。`C-c T` の最後は大文字なので `shift + t`。

### treemacs のツリー内

| キー | 動作 |
|---|---|
| `RET` | 開く／展開 |
| `TAB` | 展開のみ（フォーカスは移さない） |
| `q` | 閉じる（状態は保持される） |
| `Q` | バッファごと破棄 |
| `?` | ヘルプ（全キー一覧） |

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
| `s` / `S` | ステージ（カーソル位置 / 全部） |
| `u` | アンステージ |
| `c c` | コミット → メッセージ入力 → `C-c C-c` で確定（`C-c C-k` で中止） |
| `P p` | push（upstream へ） |
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

### 標準のウィンドウ操作（参考）

| キー | 動作 |
|---|---|
| `C-x 2` / `C-x 3` | 上下 / 左右に分割 |
| `C-x 0` / `C-x 1` | 今のを閉じる / 他を全部閉じる |
| `C-x o` | 次のウィンドウへ |
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
| `treemacs-width` | 45 | 幅（デフォルトは 35） |
| `treemacs-follow-mode` | 有効 | 編集中のバッファをツリー側で自動追跡 |
| `treemacs-filewatch-mode` | 有効 | ファイルの増減を検知して自動更新 |
| `treemacs-git-mode` | `'simple` | git の状態でファイル名を色分け（git コマンドのみ使用） |

アイコンは `treemacs-nerd-icons` で nerd-icons に統一する（既定はビットマップ画像）。

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

### 9. Git（magit + diff-hl）

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

### 10. tree-sitter（構文解析ベースのハイライト）

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

### 11. macOS のタイトルバー

macOS のタイトルバーは OS 側の描画なので任意色にできない。`ns-transparent-titlebar` で透過させ、フレーム背景と一体化させる方式を採る（Emacs 26 で導入された NS ポートのフレームパラメータ）。

```elisp
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
```

---

## 変更するときのメモ

- **色を確認したい**: `M-x list-faces-display` で定義済みフェイスを実際の見た目付きで一覧、`M-x customize-face` で個別編集
- **`customize-face` で保存すると** `custom-set-faces` ブロックに書き込まれ、手書きの `set-face-attribute` と混ざって分かりにくくなる。どちらかに寄せること（現状は手書きに統一）
- **テーマを変える**: `load-theme` の行を差し替えるだけ。外枠の配色は advice で維持される
- **パッケージを増やす**: `my/required-packages` に追記すれば次回起動時に自動で入る。新しいフェイスに色を付ける場合は `my/apply-peacock-chrome` に足す（適用は末尾で行われるので順序は気にしなくてよい）
- **treemacs の幅を変える**: `treemacs-width` を書き換える。ただし `treemacs-width-is-initially-locked` が `t` なのでマウスのドラッグでは変わらない。一時的に変えるならツリー内で `treemacs-toggle-fixed-width` → `treemacs-increase-width` / `treemacs-decrease-width`
- **tree-sitter の言語を足す**: `treesit-language-source-alist` に追記して `M-x treesit-install-language-grammar`。**バージョンを固定すること**（ABI の項を参照）
