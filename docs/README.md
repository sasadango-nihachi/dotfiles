# docs/

**設定ファイルの実体に紐づく解説**を置く。設定ファイルと 1:1 で対応させる。

使い方・キー一覧・チートシートは **tank リポジトリの `library/<ツール名>/`** に置く
（`~/code/tank/library/`）。ここには置かない。

## 線引き

| ここ（dotfiles/docs） | tank/library/\<ツール名\>/ |
|---|---|
| この設定ファイルが何をしているか | そのツールの使い方 |
| なぜそう書いたか（採用理由・トレードオフ） | キー一覧・チートシート |
| 別環境への導入手順 | 立ち位置・他ツールとの使い分け |
| 変更するときの注意 | 調査して分かった仕組み |

判断に迷ったら「**設定ファイルを消したらこの文書は無意味になるか**」で決める。
無意味になるならここ、独立して読めるなら tank。

## 一覧

| ファイル | 対応する設定 |
|---|---|
| [emacs/init_config.md](emacs/init_config.md) | `.emacs.d/init.el` |
| [nvim/nvim_config.md](nvim/nvim_config.md) | `.config/nvim/`（LazyVim）と `.config/nvim-bare/` |
| [vim/vimrc_config.md](vim/vimrc_config.md) | `.vimrc` |
| [wezterm/wezterm_config.md](wezterm/wezterm_config.md) | `.wezterm.lua` |
| [tmux/tmux_config.md](tmux/tmux_config.md) | `.tmux.conf` |
| [git/git_config.md](git/git_config.md) | `.gitconfig` / `.gitignore_global` |
| [jrnl/jrnl_config.md](jrnl/jrnl_config.md) | `.config/jrnl/jrnl.yaml` |
| [hyper/hyper_config.md](hyper/hyper_config.md) | `.hyper.js`（WezTerm へ移行済み） |
| [windows/windows_env.md](windows/windows_env.md) | Windows 環境の構築手順（`windows_env/`） |

`.zshrc` は鍵・認証情報を含みうるため解説を置かない。

## 経緯

もともと dotfiles が tank より先にあり、`docs/` に使い方も混在していた（3000行）。
2026-08-19 に上の線引きで分離し、使い方は tank の `library/` へ移した。
移動先: `library/emacs/` `library/vim/` `library/git/` `library/wezterm/`
`library/tmux/` `library/neovim/`。
