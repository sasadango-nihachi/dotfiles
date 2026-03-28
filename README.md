# dotfiles
- configファイルを管理するリポジトリ
- $HOME直下にこのリポジトリを配置する

## 対応ファイル
- vim
    - ~/.vimrc
- tmux 
    - ~/.tmux.conf
- zsh
    - .zshrc
    - .zprofile (Key情報はこっちにある ※githubには入れない)
- wezterm
    - .wezterm.lua
- bash
    - .bash_profile
    - .bashrc 
- git 
    - .gitconfig
    - .gitignore_global
- Brewfile
    - brewのリストdumpしておこうかな

## TODO

- [ ] VSCode設定の管理を追加する
  - `settings.json` をシンボリックリンクでdotfiles管理にする
  - `extensions.txt`（`code --list-extensions` の出力）を管理する
  - `keybindings.json` も必要に応じて追加
  - install.shへの組み込み方針を決める

## シンボリックリンク
```
# .vimrc
ln -sf $HOME/dotfiles/.vimrc ~/.vimrc
```

## インストール方法
```
./install.sh
```