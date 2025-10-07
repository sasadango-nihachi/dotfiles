# fugitive.vim (:Git) とgitコマンドの対応表と推奨設定

## 基本的な操作

| 操作 | fugitive (:Git画面) | fugitiveコマンド | gitコマンド |
|------|-------------------|-----------------|------------|
| ステータス確認 | `:Git` または `:G` | `:Git status` | `git status` |
| ファイルをステージング | カーソルを合わせて `s` | `:Git add %` (現在のファイル) | `git add <file>` |
| ステージング解除 | カーソルを合わせて `u` | `:Git reset %` | `git reset <file>` |
| ステージング切り替え | カーソルを合わせて `-` | - | `git add` / `git reset` |
| 差分表示 | カーソルを合わせて `=` | `:Gdiff` | `git diff <file>` |
| ファイルを開く | カーソルを合わせて `Enter` | `:Gedit <file>` | - |
| 変更を破棄 | カーソルを合わせて `X` | `:Git checkout %` | `git checkout -- <file>` |
| コミット | `cc` | `:Git commit` | `git commit` |
| コミット（修正） | `ca` | `:Git commit --amend` | `git commit --amend` |
| ヘルプ表示 | `g?` | `:help fugitive` | `git help` |

## Gitステータス画面の表示方法

| 表示方法 | コマンド | 説明 |
|---------|---------|------|
| 通常表示 | `:Git` | 現在のウィンドウに表示 |
| 水平分割 | `:split \| Git` | 上下に分割して表示 |
| 垂直分割（左） | `:vsplit \| Git` | 左右に分割して左側に表示 |
| 垂直分割（右） | `:vert Git` | 垂直分割で表示 |
| 右側に表示 | `:vert botright Git` | 右側に分割して表示 |
| 右側に幅指定 | `:vert botright Git \| vertical resize 40` | 右側に幅40で表示 |
| 幅指定で分割 | `:40vsplit +Git` | 40列幅の垂直分割で表示 |

## コミット関連

| 操作 | fugitiveコマンド | gitコマンド |
|------|-----------------|------------|
| コミット（メッセージ付き） | `:Git commit -m "message"` | `git commit -m "message"` |
| 直前のコミット修正 | `:Git commit --amend` | `git commit --amend` |
| 空コミット | `:Git commit --allow-empty` | `git commit --allow-empty` |

## ブランチ・マージ関連

| 操作 | fugitiveコマンド | gitコマンド |
|------|-----------------|------------|
| ブランチ一覧 | `:Git branch` | `git branch` |
| ブランチ切り替え | `:Git checkout <branch>` | `git checkout <branch>` |
| ブランチ作成+切り替え | `:Git checkout -b <branch>` | `git checkout -b <branch>` |
| マージ | `:Git merge <branch>` | `git merge <branch>` |
| リベース | `:Git rebase <branch>` | `git rebase <branch>` |

## リモート操作

| 操作 | fugitiveコマンド | gitコマンド |
|------|-----------------|------------|
| プル | `:Git pull` | `git pull` |
| プッシュ | `:Git push` | `git push` |
| 強制プッシュ | `:Git push --force` | `git push --force` |
| フェッチ | `:Git fetch` | `git fetch` |
| リモート確認 | `:Git remote -v` | `git remote -v` |

## ログ・履歴

| 操作 | fugitiveコマンド | gitコマンド |
|------|-----------------|------------|
| ログ表示 | `:Git log` | `git log` |
| ログ（1行表示） | `:Git log --oneline` | `git log --oneline` |
| ログ（グラフ表示） | `:Git log --graph` | `git log --graph` |
| blame表示 | `:Gblame` または `:Git blame` | `git blame <file>` |
| 特定ファイルの履歴 | `:0Gclog` | `git log -p <file>` |

## リセット・取り消し

| 操作 | fugitiveコマンド | gitコマンド |
|------|-----------------|------------|
| ソフトリセット | `:Git reset --soft HEAD~1` | `git reset --soft HEAD~1` |
| ミックスリセット | `:Git reset HEAD~1` | `git reset HEAD~1` |
| ハードリセット | `:Git reset --hard HEAD~1` | `git reset --hard HEAD~1` |
| コミット取り消し（revert） | `:Git revert HEAD` | `git revert HEAD` |
| 変更を一時保存 | `:Git stash` | `git stash` |
| 一時保存を戻す | `:Git stash pop` | `git stash pop` |

## 推奨設定（.vimrc）

### 基本設定

```vim
" leaderキーの設定（スペースキーを推奨）
let mapleader = " "

" 分割ウィンドウを右側/下側に開く
set splitright
set splitbelow
```

### Git操作のショートカット

```vim
" === 基本的なGit操作 ===
" Gitステータスを右側に表示（幅40）
nnoremap <leader>gs :vert botright Git \| vertical resize 40<CR>

" 現在のファイルをステージング+保存
nnoremap <leader>gw :Gwrite<CR>

" コミット
nnoremap <leader>gc :Git commit<CR>

" プッシュ
nnoremap <leader>gp :Git push<CR>

" プル
nnoremap <leader>gl :Git pull<CR>

" ログ確認（1行表示）
nnoremap <leader>gL :Git log --oneline --graph<CR>

" 差分確認
nnoremap <leader>gd :Gdiff<CR>

" blame表示
nnoremap <leader>gb :Gblame<CR>

" ブランチ一覧
nnoremap <leader>gB :Git branch<CR>
```

### カスタム関数

```vim
" === Gitステータスを固定幅で開く関数 ===
function! GitStatusRight()
    vert botright Git
    vertical resize 40
endfunction
command! GS call GitStatusRight()

" === ウィンドウレイアウトのバリエーション ===
" 右側に幅50で表示
nnoremap <leader>gS :vert botright Git \| vertical resize 50<CR>

" 下側に高さ15で表示
nnoremap <leader>g- :botright Git \| resize 15<CR>

" タブで開く
nnoremap <leader>gt :tab Git<CR>
```

### GitHub連携設定（gh使用時）

```vim
" === GitHub CLIとの連携 ===
" PRを作成
nnoremap <leader>gpr :!gh pr create<CR>

" PRリストを確認
nnoremap <leader>gpl :!gh pr list<CR>

" Issue作成
nnoremap <leader>gi :!gh issue create<CR>
```

### Git設定の自動化

```bash
#!/bin/bash
# setup-git.sh - ghの情報でgit configを設定

if gh auth status &>/dev/null; then
    GH_USER=$(gh api user --jq .login)
    git config --global user.name "$GH_USER"
    git config --global user.email "${GH_USER}@users.noreply.github.com"
    echo "Git config updated for: $GH_USER"
else
    echo "Please login first: gh auth login"
fi
```

## Tips

- `:Git`の後にそのままgitコマンドを入力できる（例：`:Git stash list`）
- `:Git!`で実行結果を新しいバッファで開く
- 多くのfugitiveコマンドは`%`で現在のファイルを指定できる
- `:Git`画面では`?`でコンテキストヘルプが表示される
- `|`（パイプ）を使って複数のコマンドを連結できる
- ウィンドウサイズは `<C-w> >` や `<C-w> <` でも調整可能
- `gh`認証とgit configは別々に設定が必要

## クイックリファレンス

### よく使うコマンドの流れ

1. **変更を確認**: `:vert botright Git | vertical resize 40`
2. **ファイルをステージング**: カーソルを合わせて `s`
3. **コミット**: `cc` → メッセージ入力 → `:wq`
4. **プッシュ**: `:Git push`

### トラブルシューティング

#### コミット著者が正しくない場合
```bash
# GitHubユーザー名を確認
gh api user --jq .login

# Git設定を更新
git config --global user.name "your-github-username"
git config --global user.email "your-github-username@users.noreply.github.com"
```

#### 空のコミットメッセージエラー
- コミット画面の**1行目**にメッセージを入力
- `#`で始まる行はコメントなので避ける
- 必ず`:wq`で保存して終了

#### NERDTreeとの併用時の問題
```vim
" .vimrcに追加して分割位置を制御
set splitright  " vsで右側に開く
set splitbelow  " spで下側に開く
```