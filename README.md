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

## シンボリックリンク
```
# .vimrc
ln -sf $HOME/dotfiles/.vimrc ~/.vimrc
```

## インストール方法
```
./install.sh
```