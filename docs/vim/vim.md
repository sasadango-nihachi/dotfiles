# Vimの利用まとめ

## vi or vim でファイルを開く
- vi or vimコマンドでvimそのものを起動
- そのあと 「:e file.py」でファイルを開くことができる。

## insertモードに入る
- iキーでカーソルの一でinsert 
- oキーでカーソルのしたの行でinsert 
- ccキー（c単体もある）では行を削除してinsert
- ddキーは削除(d単体もある)
- ggでファイル先頭
- Gで末尾
- 0で行頭
- $で行末

## VISUALモード
- v -> 文字単位のモード
- V -> 行単位のビジュアルモード
- Ctrl + v 矩形（ブロック）ビジュアルモード
```
y    " ヤンク（コピー）
d    " 削除（カット）
c    " 変更（削除して挿入モード）
p    " ペースト（選択範囲と置換）
~    " 大文字/小文字を切り替え
u    " 小文字に変換
U    " 大文字に変換
>    " インデント
<    " アンインデント
=    " 自動インデント
```

# スワップモードについて
- ファイル編集中の状態が保存されるファイル
- 途中で切れてしまったり正常終了しなかった場合そのファイルから復元可能
- エラーの場合「r」で復元、「d」でデリート
- 同じ環境にswapファイルを出力する場合は
    - set directory=$HOME/.vim/swap//

## 矢印キー & カーソル移動
- h : 左
- j : 下
- k : 上
- l : 右

```
  k
h   l
  j
```
- 5kで五行上
- 5jで五行下

- w : 単語の先頭(word)
- e : 単語の末尾(end)
- b : 単語の先頭に戻る(backward) あまり使わないかも？
上記大文字にすると大雑把に動く（空白単位）らしい

- { : 段落単位で後ろに進む
- } : 段落単位で前に進む

## アンドゥとリドゥ
- uキーで直前の操作取り消し
- Ctrl+rでリドゥ
- set unfofileを使うと永続的に保管可能、.vimrcに追加で処理すると環境も汚さない

## プラグイン追加
- プラグイン保存ディレクトリ
    - mkdir -p ~/.vim/pack/plugins/start

- プラグインをgitで追加
    - git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/plugins/start/nerdtree
    - git clone https://github.com/tpope/vim-vinegar.git ~/.vim/pack/plugins/start/vim-vinegar
    - git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/pack/plugins/start/crtlp 

## ワークスペースを整える
- バッファ
    - ファイルを開いた状態で、「:ls」
    - そうするとバッファを持ったファイル（一度ひらいてるファイルなのかな？）が一覧になる
    - IDがあるので、「:b 1」とかで指定するとファイルが開く「:bd」で消える

- プラグイン紹介
    - unimpaired
        - "[" と "]" を使った対になる便利な操作（次/前のエラーへジャンプ、空行挿入、ファイル切り替えなど）を追加するTim Pope製プラグイン。
        - 例：]q/[qでquickfix移動、]b/[bでバッファ切り替え、]<Space>で下に空行追加など。

- ウィンドウ作成・削除・移動
    - ファイルを開いた状態で「:split animals/cat.py」とやるとファイルが開く
    - 「:sp」と省略可能
    - 「:vsplit farm.py」で縦分割
    - 「:vs」で省略
    - Ctrl+wのあと、h,j,k,lを押すとwindowを移動できる
    - ctrl + hとかでいどうできるようにマッピングも可能ではある、これは.vimrcに書いておく
    - 「:qa」で全てのウインドウを閉じる「:wqa」で保存して閉じれる
    - Ctrl + w のあと Shirt + h(つまり大文字)でwindowの場所を移動できる。
    - Ctrl + = で全てのwindowが自動リサイズされる
    
- ウィンドウリサイズ
    - :resize N は高さをN行
    - :vertical resoize N は幅をN列にする

- タブ
    - :tabnew
    - :tabnew ファイル名
    - gt or :tabnextで移動
    - gT or :tabpreviousで前のタブに移動
    - :tabcloseで閉じれる

- 折り畳み
    - .vimrcにindentベースで折りたたむのをセットした
    - zoでおりたたみはひらく
    - zcでおりたたむ
    - zaで折りたたみをトグル
    - zRで全ての折りたたみをひらく
    - zMでずべての折りたたみを閉じる
    - 折りたたみの種類(foldmethod) 
        - manual : 手動の折り畳み
        - indent : インデントベース
        - expr   : Vimの式を使う
        - marker : {{{ や }}}のような特別なマークアップを使う
        - syntax : 構文ベースの折り畳み（pythonとかはサポートされてない）
        - diff   : 差分モードで自動使用？

# ファイルツリーを移動する
- Netrw
    - :Exコマンドでファイル移動windowを動く
    - デフォルトだから使いやすいかも
    - dでフォルダ作成できるらしい
- wildmenuの有効か
    - .vimrcに記載すると「:e」コマンドでTAB補完が効く
    - ここからファイルをさがしてもいいんだろうね
- NERDTree
    - 「:NERDTree」で開ける
    - ファイル選択して、oかEnterを押せばファイルが開く
    - hjklでTreeを移動できる
    - 「:Bookmark」or Tree上でBを押すとブックマークが開く
    - カーソル合わせて「:Bookmart」 or「:Bookmart <name>」で登録 
    - B ブックマーク一覧を表示
    - D カーソル位置のブックマークを削除（Shift+d）
    - :ClearBookmarks [name]    # 特定のブックマークを削除
    - :ClearAllBookmarks        # 全ブックマークを削除
    - CCでルートにして移動
    - uでフォルダを戻る
    - :NTでショートカットできるようにしたよ
    - 本の作者はあんまつかってないとのこと
    - NERDTree上で
        - m -> a でファイル、フォルダ作成
        - m -> d で削除
    - 

- Vinegar 
    - let NERDTreeHijackNetrw = 0
    - NERDTreeがあるとデフォルトで上記を使う
    - 「-」で開くようになるってことかな？
    - Netrwの拡張？

- CtrlP
    - 曖昧検索プラグイン
    - そのまま Ctrl + pで起動
    - ESCで消える 

- 移動距離の表
```
                 gg
                 ?
                 Ctrl-b
                 H
                 {
                 k
0 ^ F T ( b ge h   l w e ) t f $
                 j
                 }
                 L
                 Ctrl-f
                 /
                 G
```

# 検索について
- 1ファイル単体の検索
    - 「/」で検索ができる
    - nで次、Nで前に移動ができる
    - set hlsearch
    - /kindでkind文字列が全てハイライト
    - :nohでハイライトが消せる
- ファイル跨いでの検索
    - :grep
        - システムのgrepを利用
    - :vimgrep
        - vim用機能
        - :vimgrep <パターン> <パス>
        - :vimgrep animal **/*.py (**で再帰的に検索できる)
        - :cnか:cpで別のマッチに移動する(ここはよくわからん)
        - Quickfixリストを開く場合は:copenを使う
        - :qで閉じるよ


# プラグインについて
- vim-plug
    - .vimrcに書き込んで
    - :PlugInstallでOK
    - これがあれば.vimrcを移動させるだけで同じものを利用できる

- NERDCommenter
    - 設定は.vimrcに記入
    - 「Ctrl + v」でVISUAL BLOCK
        - \cc : コメントアウト
        - \cu : コメントイン
        - \cA : 行末にコメント追加

- プロファイリング
    - vim --startuptime startuptime.log
    - 上記のコマンドでlogに結果がでる、遅くなったら確認


# 検索と置換
- :substitute、省略は「:s」
- :s/<置換対象>/<置換される文字列>/<フラグ>
- :s/cat/dog
- その対象の文字列のところにいって変換する
- フラグ（i、l以外は自由に組み合わせ可能）
    - g:グローバルな置換。最初のものだけでなく、行にある全ての置換対象を置き換える。
    - c:置換ごとに確認。置換前にユーザーに確かめる。
    - e:マッチ（検索一致）がなかった時にエラーを出さなくなる
    - i:検索をケースインセンシティブ（大文字小文字を区別しない）にする
    - l:検索をケースセンシティブ（大文字小文字を区別する）にする
- :%s/animal/creature/g
    - ファイル全体を指定する
    - 範囲はコマンドに前置する
    - 下にどのくらい変換したか表示されるよ
    - 範囲
        - 数字: 行番号として扱われる
        - $   : ファイルの最終行
        - %   : ファイル全体
        - /検索パターン/ : 操作したい行を探すことができる
        - ?後方検索パターン? : 後方に向かって操作したい行を探すことができる
        - 「;」で繋げる、20;$で20行目から最終行という形になる
        
- set numberの逆はset nonumber(setnonu)ね 

# ターミナルモード
- :terminal(水平)
    - 「:term」短縮系
    - :vertical terminal
    - :vert term

## Vim ターミナル使い方まとめ

| コマンド/キー | 動作 | 使用例 |
|--------------|------|--------|
| `:T` | 下に高さ10行でターミナル開く | `:T` |
| `:T python` | pythonを実行するターミナル開く | `:T npm start` |
| `:VT` | 右側に垂直分割でターミナル | `:VT` |
| `\t` | ターミナルを素早く開く | `\t` |
| `\vt` | 垂直ターミナルを素早く開く | `\vt` |
| `Esc` | ターミナル→ノーマルモード | ターミナル内でEsc |
| `Ctrl+h/j/k/l` | ウィンドウ間を移動 | `Ctrl+k`で上へ |
| `i` or `a` | ノーマル→ターミナルモード | ノーマルモードで`i` |
| `exit` | ターミナルを終了 | ターミナル内で`exit` |

- set pasteでペーストモードに入るよ
- :below terminal
- :resize 10
- 上記をパイプで使いたいね

- 「:」を押してEnterを押すと履歴が表示される


## VimでのGit
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

