# .gitignore
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
