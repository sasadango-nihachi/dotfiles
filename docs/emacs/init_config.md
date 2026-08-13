# Emacs 設定（init.el）について

管理対象: `~/dotfiles/.emacs.d/init.el` → `~/.emacs.d/init.el`（シンボリックリンク）

対象環境: GNU Emacs 30.2 (aarch64-apple-darwin, NS port) / macOS

キーバインドの学習メモは [emacs.md](./emacs.md) を参照。こちらは設定ファイルの中身の記録。

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

空の `HOME` を作ってそこから起動させたところ、4パッケージが自動導入され、アイコン（`a.py` → U+E73C）まで解決することを確認済み。

---

## 設定の中身

### 1. パッケージ管理（自己ブートストラップ）

MELPA を追加し、`my/required-packages` の未導入分を起動時に自動インストールする。

| パッケージ | 役割 |
|---|---|
| `nerd-icons` | Nerd Font のアイコンライブラリ。以下3つの土台 |
| `doom-modeline` | モダンなモードライン |
| `nerd-icons-dired` | dired のファイル一覧にアイコン |
| `nerd-icons-completion` | 補完候補にアイコン |

インストール失敗時は `condition-case` で握り潰してメッセージだけ出す。1つのパッケージが取れなくても Emacs が起動不能にならないようにするため。

### 2. 起動時の挙動

- `inhibit-startup-screen` — スプラッシュ画面を消す
- `initial-scratch-message` — `*scratch*` 冒頭のコメントを消す

### 3. テーマ

Emacs 同梱の **`misterioso`**（青緑系の暗い背景、`#2d3743`）。追加パッケージ不要。

同梱テーマは他に modus-vivendi / modus-operandi（高可読・アクセシビリティ準拠）、wombat、deeper-blue など全23個。一覧は `M-x customize-themes`。

### 4. アイコン

`Symbols Nerd Font Mono` を使う。**このフォントが無いとアイコンが全部豆腐（□）になる**。

`(display-graphic-p)` で GUI 判定してから `find-font` で有無を確認し、無ければ自動インストールする。端末起動時は `find-font` が使えないのでスキップする。

手動で入れ直す場合: `M-x nerd-icons-install-fonts`

なお macOS 側には `HackGen Console NF`（日本語対応の Nerd Font パッチ済みフォント）も入っている。既定フォントをこれにすればフォールバックなしでアイコンが描画される。

```elisp
(set-face-attribute 'default nil :family "HackGen Console NF" :height 140)
```

### 5. UI の配色（VSCode Peacock 相当）

VSCode の Peacock 拡張と同じ考え方で、**エディタ本体ではなく「外枠」だけを塗る**。エディタの配色はテーマ（misterioso）のまま残す。

パレット:

| 色 | 用途 | VSCode での対応 |
|---|---|---|
| `#8B0000` | モードライン背景 | `statusBar.background` |
| `#E8A24A` | 前景（琥珀） | `statusBar.foreground` |
| `#C17A30` | アクティブ・境界線 | `activityBar.activeBackground` / `sash.hoverBorder` |
| `#1A0A00` | タブバー背景 | `activityBar.background` |
| `#5E0400` | 非アクティブ背景 | `titleBar.inactiveBackground` (`#8B000099`) |
| `#96652C` | 非アクティブ前景 | `activityBar.inactiveForeground` (`#E8A24A99`) |

**アルファ値について**: Emacs のフェイスは透明度を持てない。VSCode 側の `#E8A24A99`（アルファ 0x99 = 60%）のような指定は、背景色 `#1A0A00` の上で**事前に合成した不透明色**に変換する必要がある。

```
#E8A24A を 60% で #1A0A00 に合成 → #96652C
#8B0000 を 60% で #1A0A00 に合成 → #5E0400
```

配色は `my/apply-peacock-chrome` 関数にまとめてあり、`load-theme` に `advice-add` で後掛けしている。**テーマを切り替えても外枠の配色が失われない**ようにするため（テーマ読み込みはフェイスをリセットするので、後から上書きし直す必要がある）。

対応しないもの:

- **activityBar**（左のアイコン列）— Emacs に相当する常設 UI が無い。タブバーに割り当てている
- **activityBarBadge** — バッジという概念が無い

### 6. macOS のタイトルバー

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
- **パッケージを増やす**: `my/required-packages` に追記すれば次回起動時に自動で入る
