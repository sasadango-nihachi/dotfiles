# WezTerm 設定（.wezterm.lua）について

管理対象: `~/dotfiles/.wezterm.lua` → `~/.wezterm.lua`（シンボリックリンク）

使い方・既定のキーバインドは tank の `~/code/tank/library/wezterm/` を参照。
ここは設定ファイルの中身の記録。

**設定の中身そのものはコピーしない**（以前この文書に `.wezterm.lua` を丸ごと貼っていたが、
実ファイルと乖離した。opacity が 0.65 のまま・フォント行が無い、など）。ここには
「なぜそう書いたか」だけを書く。

---

## 見た目

| 設定 | 値 | 意図 |
|---|---|---|
| `config.font` | `HackGen Console NF` | 日本語対応 + Nerd Font パッチ済み。Emacs の既定フォントと揃えてある |
| `config.font_size` | 15 | |
| `config.color_scheme` | `Homebrew` | Tokyo Night / Dracula / Apple Classic / Kanagawa 系は候補としてコメントで残してある |
| `config.window_background_opacity` | 0.85 | 背景を透過させる |
| `config.macos_window_background_blur` | 10 | 透過した背景をぼかす（macOS 限定） |

配色候補をコメントで並べてあるのは、気分で切り替えるため。使うものだけ有効行にする。

## tmux 風のリーダーキー

**tmux を入れずに WezTerm 単体でペイン運用する**ための設定。

```lua
config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 3000 }
```

リーダーは `Ctrl+g`。tmux 既定の `Ctrl+b` を避けているのは、Vim/Emacs の
`Ctrl+b`（1画面戻る / backward-char）と衝突するため。

`timeout_milliseconds = 3000` は「リーダーを押してから次のキーまで3秒」。
**1回の操作ごとにリーダーを押し直す必要がある**（押しっぱなしで連打はできない）。

| キー | 動作 |
|---|---|
| `LEADER \|` / `LEADER %` | 左右に分割 |
| `LEADER -` / `LEADER "` | 上下に分割 |
| `LEADER h/j/k/l` | ペイン間を移動（矢印キーでも可） |
| `LEADER H/J/K/L` | ペインのサイズ調整 |
| `LEADER c` | 新しいタブ |
| `LEADER x` | ペインを閉じる（確認あり） |
| `LEADER z` | ペインの最大化トグル |
| `LEADER o` | ペインを時計回りに回転 |
| `LEADER q` | ペインを番号で選択 |
| `LEADER n` / `LEADER p` | 次 / 前のタブ |
| `LEADER 1` / `LEADER 2` | タブ番号で切り替え（3-9 は未定義） |

### サイズ調整の移動量を 15 にしてある理由

`act.AdjustPaneSize` の第2引数は1回あたりのセル数。リーダーが3秒タイムアウト式で
**連打が効かない**ため、1回の移動量を大きめに取らないと実用にならない。

## 変更するときのメモ

- 配色を変えるときは、有効な `config.color_scheme` 行を1本だけにする
- キーを足すときは `config.keys` の表に追記し、上のキー表も更新する
- タブ番号 3-9 を足すなら `act.ActivateTab(n-1)` を並べる
