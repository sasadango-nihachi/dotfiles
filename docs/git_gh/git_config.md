# Git 設定（.gitconfig / .gitignore_global）について

管理対象:

- `~/dotfiles/.gitconfig` → `~/.gitconfig`
- `~/dotfiles/.gitignore_global` → `~/.gitignore_global`

git / gh コマンドの使い方は tank の `~/code/tank/library/git/` を参照。
ここは設定ファイルの中身の記録。

---

## .gitconfig

```ini
[core]
        excludesfile = ~/.gitignore_global
[submodule]
        recurse = true
[include]
        path = ~/.gitconfig.local
```

| 設定 | 意図 |
|---|---|
| `core.excludesfile` | 全リポジトリ共通の除外リストとして `~/.gitignore_global` を使う |
| `submodule.recurse = true` | `clone` / `pull` / `checkout` で submodule も自動で追随させる。付けないと submodule が古いコミットのまま置き去りになる |
| `include.path` | **`user.name` / `user.email` は PC ごとに違うので dotfiles では管理しない。** 各マシンの `~/.gitconfig.local`（dotfiles 管理外）に書き、それを読み込む |

`~/.gitconfig.local` は install.sh の対象外なので、新しい環境では自分で作る。

```bash
git config -f ~/.gitconfig.local user.name  "<name>"
git config -f ~/.gitconfig.local user.email "<email>"
```

---

## .gitignore_global（192行）

エディタ・OS が撒く作業ファイルを、全リポジトリで共通に無視する。
**プロジェクト固有の除外はリポジトリ側の `.gitignore` に書く**（ここに書くと
他人のリポジトリで意図せず効いてしまう）。

カバーしている範囲:

| 区分 | 対象 |
|---|---|
| Vim | swap（`*.swp`）/ backup（`*~`）/ undo / セッション / tags / netrw |
| Neovim | プラグインマネージャの lock、LSP のキャッシュ |
| Emacs | backup / auto-save / lock / `.dir-locals` / Projectile / 生成物・パッケージング / server auth / desktop / TAGS / org-mode / eshell / ELPA / Flycheck / straight.el / Doom / Spacemacs / 一時ファイル |
| おまけ | VS Code / JetBrains IDEs / Sublime Text |
| macOS | `.DS_Store` ほか |

以下は当時の設定手順と内容の記録。

```bash
# 設定
git config --global core.excludesfile ~/.gitignore_global

# 設定確認
git config --global core.excludesfile

```

```.gitignore
#===========================================
# Vim
#===========================================
# Swap files
*.swp
*.swo
*.swn
# Backup files
*~
*.bak
*.tmp
# Undo files
*.un~
# Session
Session.vim
Sessionx.vim
# Auto-generated tags
tags
tags.lock
tags.temp
# netrw
.netrwhist

#===========================================
# Neovim
#===========================================
# Neovim specific
.luarc.json
.nvim.lua
.nvimrc
.exrc
# Plugin manager lock files
lazy-lock.json
packer_compiled.lua
plugin/packer_compiled.lua
# LSP
.nvim/
.vim/

#===========================================
# Emacs
#===========================================
# Backup files
\#*\#
.\#*
# Auto-save files
auto-save-list
# Lock files
.~lock.*#
# Directory configuration
.dir-locals.el
.dir-locals-2.el
# Projectile
.projectile
# Compiled
*.elc
# Packaging
.cask/
dist/
# Server auth directory
/server/
# Emacs desktop
.emacs.desktop
.emacs.desktop.lock
# TAGS
TAGS
!TAGS/
GTAGS
GRTAGS
GPATH
GSYMS
# Org-mode
.org-id-locations
*_archive
*_flymake.*
# Eshell
eshell/history
eshell/lastdir
# ELPA packages
/elpa/
# Flycheck
flycheck_*.el
# Straight.el
straight/repos/
straight/build/
# Doom Emacs
.doom.d/cache/
.doom.d/env
# Spacemacs
*~
\#*\#
/.emacs.desktop
/.emacs.desktop.lock
*.elc
auto-save-list
.cache/
.lsp/
# Emacs temp files
*.log
*~

#===========================================
# VS Code (おまけ)
#===========================================
.vscode/
*.code-workspace
.history/

#===========================================
# JetBrains IDEs (おまけ)
#===========================================
.idea/
*.iml
*.iws
*.ipr
out/
.idea_modules/

#===========================================
# Sublime Text (おまけ)
#===========================================
*.sublime-project
*.sublime-workspace
*.tmlanguage.cache
*.tmPreferences.cache
*.stTheme.cache

#===========================================
# macOS
#===========================================
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

#===========================================
# Linux
#===========================================
.Trash-*
.nfs*

#===========================================
# Windows
#===========================================
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db
Desktop.ini
$RECYCLE.BIN/

#===========================================
# その他の一般的な除外項目
#===========================================
# 環境変数・秘密情報
.env
.env.*
*.pem
*.key
*.cert
*.crt
.secrets
.credentials

# ログ・キャッシュ
*.log
logs/
*.cache
.cache/
tmp/
temp/

# バックアップ
*.backup
*.old
*.orig
*

```
