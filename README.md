# dotfiles
- configファイルを管理するリポジトリ
- $HOME直下にこのリポジトリを配置する

## 対応ファイル
- vim
    - ~/.vimrc
- neovim
    - ~/.config/nvim/ （LazyVimベース、catppuccin-mocha）
    - ~/.config/nvim-bare/ （素のNeovim実験用、`NVIM_APPNAME=nvim-bare nvim` / alias `nvb` で起動）
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
- パッケージの記録（シンボリックリンクは張らない）
    - `Brewfile` （tap / formula / cask / VS Code拡張。`brew bundle dump` の生成物）
        - 復元: `brew bundle install --file=~/dotfiles/Brewfile`
    - `volta.txt` （nodeランタイムとvolta管理のグローバルパッケージ。`volta list all` の生成物）
        - voltaは `npm install -g` を横取りするので `brew bundle dump --npm` では拾えず、別ファイルにしている
    - 手順・注意は [docs/brew/brewfile.md](docs/brew/brewfile.md)

## TODO

- [ ] VSCode設定の管理を追加する
  - `settings.json` をシンボリックリンクでdotfiles管理にする
  - [x] ~~`extensions.txt`（`code --list-extensions` の出力）を管理する~~ → `Brewfile` の `vscode "..."` 行で代替済み
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