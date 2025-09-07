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
