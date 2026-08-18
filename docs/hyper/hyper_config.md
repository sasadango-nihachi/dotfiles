# Hyper 設定（.hyper.js）について

管理対象: `~/dotfiles/.hyper.js` → `~/.hyper.js`（シンボリックリンク）

Hyper は Electron 製の端末エミュレータ。**現在の主力は WezTerm**（`docs/wezterm/`）で、
これは以前使っていた設定を残してあるもの。

---

## 中身

| 設定 | 値 | 意図 |
|---|---|---|
| `fontSize` | 14 | |
| `fontFamily` | `Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace` | |
| `cursorColor` | `#FF5555` | 明るい赤で見失わないように |
| `cursorShape` | `BEAM` | ビーム型 |
| `cursorBlink` | true | |
| `foregroundColor` | `#FFFFFF` | 純白 |
| `backgroundColor` | `rgba(0, 0, 0, 0.7)` | 背景を透過 |
| `shellArgs` | `['--login']` | ログインシェルとして起動し、`.zprofile` を読ませる |

`shell` は空文字（`''`）で、OS 既定のシェルを使う。

## 位置づけ

Electron ベースなので WezTerm（GPU レンダリング、Rust）に比べて重い。
乗り換え済みだが、設定自体は消さずに残している。

- WezTerm の設定 — `docs/wezterm/wezterm_config.md`
- 端末の選定まわり — `~/code/tank/library/keyboard-driven-mac/`
