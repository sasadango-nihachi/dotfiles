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

# ghコマンド
- gh auth login
- これでログインできる

## リポジトリ操作
```
# リポジトリをクローン
gh repo clone owner/repo
gh repo clone rails/rails

# 新規リポジトリ作成（カレントディレクトリ）
gh repo create my-project --public
gh repo create my-project --private --clone

# リポジトリをブラウザで開く
gh repo view --web
gh browse  # 短縮形

# フォーク
gh repo fork owner/repo --clone
```

## Pull Request 操作
```
# PR作成（現在のブランチから）
gh pr create
gh pr create --title "Fix bug" --body "Fixed the login issue"
gh pr create --fill  # コミットメッセージから自動入力
gh pr create --draft  # ドラフトPR

# PR一覧
gh pr list
gh pr list --author @me  # 自分のPR
gh pr list --assignee @me
gh pr list --state all

# PR確認
gh pr view 123
gh pr view  # 現在のブランチのPR
gh pr view --web  # ブラウザで開く

# PRをチェックアウト
gh pr checkout 123
gh pr checkout 123 --branch fix-bug  # ブランチ名指定

# PRレビュー
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Please fix the typo"
gh pr review 123 --comment --body "LGTM"

# PRマージ
gh pr merge 123
gh pr merge 123 --squash
gh pr merge 123 --rebase
gh pr merge --auto  # 自動マージを有効化

# PR状態確認
gh pr status
gh pr checks  # CI/CDの状態確認
```

## Issue操作
```
# Issue作成
gh issue create
gh issue create --title "Bug report" --body "Description"
gh issue create --assignee @me --label bug

# Issue一覧
gh issue list
gh issue list --assignee @me
gh issue list --label "bug"
gh issue list --state all

# Issue確認
gh issue view 42
gh issue view 42 --web

# Issueを閉じる/再開
gh issue close 42
gh issue reopen 42

# コメント追加
gh issue comment 42 --body "Working on this"
```

## GitHub Actions/Workflow
```
# ワークフロー一覧
gh workflow list

# ワークフロー実行
gh workflow run deploy.yml
gh workflow run deploy.yml -f environment=production

# 実行状況確認
gh run list
gh run view
gh run watch  # リアルタイム監視

# ログ確認
gh run view --log
gh run view --log-failed  # 失敗したステップのみ
```

## Gist操作
```
# Gist作成
gh gist create file.txt
gh gist create *.md --public
echo "Hello" | gh gist create

# Gist一覧・確認
gh gist list
gh gist view GIST_ID
gh gist edit GIST_ID
```

## Release 操作
```
# リリース作成
gh release create v1.0.0
gh release create v1.0.0 --title "Version 1.0.0" --notes "Release notes"
gh release create v1.0.0 --generate-notes  # 自動生成

# リリース一覧
gh release list

# アセットをダウンロード
gh release download v1.0.0
```

## 便利なエイリアス設定
```
# よく使うコマンドをエイリアス化
gh alias set prs 'pr list --author @me'
gh alias set reviews 'pr list --reviewer @me'
gh alias set issues 'issue list --assignee @me'
gh alias set co 'pr checkout'
gh alias set web 'repo view --web'

# 使用例
gh prs      # 自分のPR一覧
gh reviews  # レビュー待ちのPR
gh co 123   # PR #123をチェックアウト
```

## 便利な設定
```
# デフォルトエディタ設定
gh config set editor vim

# Git プロトコル（SSH推奨）
gh config set git_protocol ssh

# ページャー設定
gh config set pager less
```

## 実践的な使用例
```
# 新機能開発フロー
git checkout -b feature/new-feature
# ... コーディング ...
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
gh pr create --fill
gh pr view --web

# コードレビューフロー
gh pr list --reviewer @me
gh pr checkout 456
# ... コードレビュー ...
gh pr review 456 --approve --body "LGTM!"

# Issue駆動開発
gh issue create --title "Add login feature"
gh issue list --assignee @me
# ... 作業 ...
gh pr create --fill --body "Closes #789"
```

# gitコマンド操作

## 初期設定
```
# ユーザー情報設定（必須）
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# エディタ設定
git config --global core.editor vim

# デフォルトブランチ名を main に
git config --global init.defaultBranch main

# 設定確認
git config --list
git config user.name  # 特定の設定値を確認
```

## リポジトリ作成・クローン
```
# 新規リポジトリ作成
git init
git init my-project  # ディレクトリ作成して初期化

# クローン
git clone https://github.com/owner/repo.git
git clone git@github.com:owner/repo.git  # SSH
git clone https://github.com/owner/repo.git my-folder  # 別名でクローン

# リモートリポジトリ追加
git remote add origin https://github.com/owner/repo.git
git remote -v  # リモート一覧
git remote remove origin  # リモート削除
```

## 基本的な作業フロー
```
# 状態確認
git status
git status -s  # 短縮表示

# ファイルをステージング
git add file.txt
git add .  # すべての変更
git add *.js  # 特定パターン
git add -p  # 対話的に部分的に追加

# コミット
git commit -m "Add feature"
git commit -am "Fix bug"  # add + commit（追跡済みファイルのみ）
git commit --amend  # 直前のコミットを修正
git commit --amend --no-edit  # メッセージ変更なし

# 差分確認
git diff  # ワーキングツリーとインデックスの差分
git diff --staged  # ステージングとHEADの差分
git diff HEAD  # ワーキングツリーとHEADの差分
git diff main...feature  # ブランチ間の差分
```

## ブランチ操作
```
# ブランチ一覧
git branch
git branch -a  # リモート含む
git branch -v  # 詳細情報付き

# ブランチ作成・切り替え
git branch feature-x
git checkout feature-x
git checkout -b feature-x  # 作成して切り替え
git switch feature-x  # 新しい切り替えコマンド
git switch -c feature-x  # 作成して切り替え（新）

# ブランチ削除
git branch -d feature-x  # マージ済みのみ
git branch -D feature-x  # 強制削除

# ブランチ名変更
git branch -m old-name new-name
git branch -m new-name  # 現在のブランチ名を変更
```

## リモート操作
```
# プッシュ
git push
git push origin main
git push -u origin feature-x  # 上流ブランチ設定
git push --force  # 強制（危険！）
git push --force-with-lease  # より安全な強制プッシュ

# プル・フェッチ
git pull  # fetch + merge
git pull --rebase  # fetch + rebase
git fetch  # リモートの変更を取得のみ
git fetch --all  # すべてのリモート
git fetch --prune  # 削除済みリモートブランチを反映
```

## マージ・リベース
```
# マージ
git merge feature-x
git merge --no-ff feature-x  # fast-forwardしない
git merge --squash feature-x  # 1コミットにまとめる
git merge --abort  # マージを中止

# リベース
git rebase main
git rebase -i HEAD~3  # 直近3コミットを対話的にリベース
git rebase --continue  # コンフリクト解決後に継続
git rebase --abort  # リベースを中止

# チェリーピック（特定コミットを取り込む）
git cherry-pick abc123
git cherry-pick abc123..def456  # 範囲指定
```

## ログ・履歴確認
```
# ログ表示
git log
git log --oneline  # 1行表示
git log --graph  # グラフ表示
git log --oneline --graph --all  # 全ブランチをグラフで
git log -p  # 差分も表示
git log -3  # 直近3件
git log --since="2 weeks ago"  # 期間指定
git log --author="Name"  # 著者指定
git log --grep="fix"  # コミットメッセージ検索

# 特定ファイルの履歴
git log -- file.txt
git log -p -- file.txt  # 差分付き
git blame file.txt  # 行ごとの最終更新者

# コミット詳細
git show abc123
git show HEAD~2  # 2つ前のコミット
```

## 変更の取り消し
```
# ステージングを取り消し
git reset file.txt
git reset  # すべて取り消し

# 変更を破棄
git checkout -- file.txt  # 特定ファイル
git checkout .  # すべて
git restore file.txt  # 新しいコマンド
git restore --staged file.txt  # ステージングのみ取り消し

# コミットを取り消し
git reset --soft HEAD~1  # コミットのみ取り消し
git reset --mixed HEAD~1  # デフォルト、ステージングも
git reset --hard HEAD~1  # 変更も破棄（危険！）

# 打ち消しコミット作成
git revert abc123
git revert HEAD  # 直前のコミットs
```

## スタッシュ（一時保存）
```
# スタッシュ作成
git stash
git stash save "WIP: feature X"  # メッセージ付き
git stash -u  # 未追跡ファイルも含む

# スタッシュ確認・適用
git stash list
git stash show  # 差分確認
git stash show -p  # 詳細差分
git stash apply  # 適用（スタッシュは残る）
git stash pop  # 適用して削除
git stash apply stash@{1}  # 特定のスタッシュ

# スタッシュ削除
git stash drop
git stash clear  # すべて削除
```

## タグ操作
```
# タグ作成
git tag v1.0.0
git tag -a v1.0.0 -m "Version 1.0.0"  # 注釈付き
git tag v1.0.0 abc123  # 特定コミットに

# タグ確認
git tag
git tag -l "v1.*"  # パターン検索
git show v1.0.0

# タグをリモートへ
git push origin v1.0.0
git push origin --tags  # すべてのタグ

# タグ削除
git tag -d v1.0.0  # ローカル
git push origin --delete v1.0.0  # リモート
```

## 便利な操作
```
# ファイル削除・移動
git rm file.txt
git rm --cached file.txt  # Gitからのみ削除
git mv old.txt new.txt

# 部分的なステージング
git add -p  # 対話的に選択

# 検索
git grep "TODO"  # リポジトリ内検索
git grep -n "TODO"  # 行番号付き

# bisect（バグのあるコミットを特定）
git bisect start
git bisect bad  # 現在はバグあり
git bisect good v1.0.0  # v1.0.0は正常
# ... テストして git bisect good/bad を繰り返す
git bisect reset

# reflog（操作履歴）
git reflog  # HEAD の履歴
git reset --hard HEAD@{2}  # 2つ前の状態に戻す
```

## エイリアス設定
```
# ~/.gitconfig に追加
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --oneline --graph --all'

# 使用例
git st  # git status
git co main  # git checkout main
git lg  # ログをグラフで表示
```

## 実践的なワークフロー
```
# 機能開発フロー
git checkout main
git pull origin main
git checkout -b feature/login
# ... 開発作業 ...
git add .
git commit -m "Add login feature"
git push -u origin feature/login
# PRを作成

# バグ修正フロー
git checkout -b hotfix/critical-bug
# ... 修正 ...
git commit -am "Fix critical bug"
git checkout main
git merge --no-ff hotfix/critical-bug
git push origin main
git branch -d hotfix/critical-bug

# コミット整理（プッシュ前）
git rebase -i HEAD~3
# pick, squash, fixup, reword などで整理
git push origin feature-branch

# コンフリクト解決
git pull origin main
# ... コンフリクト解決 ...
git add .
git commit
git push
```

## 変更ファイル一覧

```
# 現在の変更状態を確認（最もよく使う）
git status
git status -s  # 短縮表示（見やすい）

# 例：短縮表示の見方
# M  file.txt     → 変更されてステージング済み
#  M file2.txt    → 変更されたが未ステージング
# ?? new.txt      → 未追跡ファイル
# A  added.txt    → 新規追加
# D  deleted.txt  → 削除

```

# コミット間の変更ファイル一覧
```
# 最新コミットの変更ファイル一覧
git diff --name-only HEAD~1
git diff --name-status HEAD~1  # 変更種別付き（A/M/D）

# 特定のコミット間
git diff --name-only abc123..def456
git diff --name-only main...feature  # ブランチ間

# より詳細な情報付き
git diff --stat HEAD~1  # 変更行数の統計付き
git diff --stat main...feature

# 例：--statの出力
# file1.txt |  5 +++--
# file2.js  | 12 ++++++++++++
# 2 files changed, 15 insertions(+), 2 deletions(-)s
```
