# tmux 設定（.tmux.conf）について

管理対象: `~/dotfiles/.tmux.conf` → `~/.tmux.conf`（シンボリックリンク）

tmux 自体の使い方は tank の `~/code/tank/library/keyboard-driven-mac/tmux.md`。
ここは設定ファイルの中身の記録。

---

## プレフィックスは既定の `Ctrl+b` のまま

`Ctrl+g` に変える設定は**書いてあるがコメントアウトされている**。

```conf
# unbind C-b
# set -g prefix C-g
# bind C-g send-prefix
```

以前のメモに「`Ctrl+b` を `Ctrl+g` に変更してる」と書いてあったが、
実ファイルは無効化されたままなので**現状は `Ctrl+b`**。
以下の表の `PREFIX` は `Ctrl+b` を指す。

なお WezTerm 側のリーダーは `Ctrl+g` にしてある（`docs/wezterm/wezterm_config.md`）。
両方使う場合はこの差に注意する。

## コピーモード（Vim スタイル）

```conf
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
set -s copy-command 'pbcopy'
```

| キー | 動作 |
|---|---|
| `v` | 選択開始（Vim と同じ） |
| `y` | クリップボードへコピーして抜ける |
| マウスドラッグ終了 | 自動でクリップボードへコピー |

macOS の `pbcopy` に流すことで、tmux のバッファではなく **OS のクリップボード**に入る。
これが無いと tmux の外に貼れない。

## マウス

```conf
set -g mouse on
```

クリックでのペイン移動、ドラッグでのリサイズ、スクロールが効くようになる。

## ペイン操作

| キー | 動作 |
|---|---|
| `PREFIX \|` | 左右に分割 |
| `PREFIX -` | 上下に分割 |
| `PREFIX h/j/k/l` | ペイン間を移動（Vim スタイル） |

既定の `%`（左右）と `"`（上下）は記号が直感的でないので、
見た目に合う `|` と `-` を割り当てている。

## その他

| 設定 | 内容 |
|---|---|
| `bind r source-file ~/.tmux.conf \; display "Reloaded"` | `PREFIX r` で設定を再読み込み |
| `base-index 1` | ウィンドウ番号を 1 始まりに（キーボードの並びと合わせる） |
| `pane-base-index 1` | ペイン番号も 1 始まりに（一貫性のため） |

## 変更するときのメモ

- プレフィックスを `Ctrl+g` に変えるなら、WezTerm のリーダーと衝突するのでどちらかを変える
- 設定を変えたら `PREFIX r` で反映（tmux の再起動は不要）
