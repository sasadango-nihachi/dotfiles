# Brewfile について

管理対象: `~/dotfiles/Brewfile` と `~/dotfiles/volta.txt`

**シンボリックリンクを張らない**のがほかの設定ファイルとの違い。`install.sh` の
`FILES[]` にも入れていない。`brew bundle` は `--file` でパスを渡せるので、
リポジトリ内の実体をそのまま指せばよく、`~/` に置く必要がない。

| ファイル | 持つもの | 生成元 |
|---|---|---|
| `Brewfile` | tap / formula / cask / VS Code 拡張 | `brew bundle dump` |
| `volta.txt` | node ランタイムと volta 管理のグローバルパッケージ | `volta list all` |

2枚に分かれているのは volta が `npm ls -g` に出ないため（後述）。

## これは何か

このマシンに入っている Homebrew パッケージの**スナップショット**。
「何を入れたか」の記録であり、新しいマシンで同じ環境を組み直すための材料。

`brew bundle` は以前は `homebrew/bundle` の tap が必要だったが、
**Homebrew 4.2 以降は本体に統合**されていて `brew tap` は不要
（このマシンは 6.0.19、`brew bundle --help` が通る）。

## 中身

`brew bundle dump` の生成物。**手書きしない**。行の種類は4つ。

| 行 | 意味 | 実測 |
|---|---|---|
| `tap "..."` | 追加している tap | 5 |
| `brew "..."` | formula（CLI ツール） | 30 |
| `cask "..."` | cask（GUI アプリ・フォント） | 18 |
| `vscode "..."` | VS Code 拡張 | 16 |

`# コメント` は各パッケージの説明で、`--describe` が既定で有効なため自動で付く。

### vscode 行

Homebrew 6 系の `brew bundle` は Homebrew のパッケージだけでなく、VS Code 拡張・
npm / cargo / go / uv / mas なども扱える。`vscode "publisher.extension"` の行は
`code --list-extensions` と同じ内容で、**拡張の管理はこれで一元化されている**
（README の TODO にあった `extensions.txt` は不要になった）。

復元は `brew bundle install` が `code --install-extension` を呼ぶ形。`code` コマンドが
必要になるが、**VS Code 側で「シェルコマンドをインストール」を実行する必要はない**。
cask の `binary` stanza が `/opt/homebrew/bin/code` へのシンボリックリンクを張るため、
`cask "visual-studio-code"` を入れた時点で PATH に乗る（実測: `/opt/homebrew/bin/code` →
`/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`）。

Brewfile 内でも `cask "visual-studio-code"` が `vscode "..."` 行より前にあるので、
新マシンで上から流せばそのまま通る。手動の前準備は要らない。

**カバーするのは拡張の一覧だけ。** `settings.json` / `keybindings.json` は対象外で、
そちらは別途シンボリックリンクでの管理を検討中（README の TODO）。拡張のバージョンも
固定されない（常に最新が入る）。

### npm 行を使っていない理由（volta）

`--no-npm` で外している。**volta を使っていると `brew bundle dump` の npm 行が
役に立たないため。**

volta は `npm install -g` を横取りして `~/.volta/tools/image/packages/` にインストールする。
一方 `brew bundle dump --npm` が見るのは `npm ls -g`（＝現在の node イメージの
`lib/node_modules`）なので、**volta で入れたものは1つも出てこない**。実測では
`mmdc` / `vue` / `create-react-app` が入っているのに `corepack` と `npm` しか出なかった。

`npm "corepack"` の1行だけが載ると「npm も記録できている」ように見えてしまうので、
種別ごと外し、**volta 管理分は `~/dotfiles/volta.txt` に分けた**。node ランタイムの
バージョンもそちらに入る（node は Homebrew 管理下にないので Brewfile には出ない）。

### 何が載って何が載らないか

載るのは「**明示的に install したもの**」で、その依存として自動で入ったものは載らない
（167 個入っているうち書き出されるのは 30）。ただし完全一致ではなく、他の formula の
依存として解決できるものは省かれることがある（実測: `pkgconf` は
`brew list --installed-on-request` に出るが Brewfile には出ない。`pyenv` /
`pyenv-virtualenv` の依存として入るので実害はない）。


## 使い方

### 新マシンでの復元（順番）

1. Homebrew を入れる
2. `brew bundle install --file=~/dotfiles/Brewfile`
   — tap → formula → cask → VS Code 拡張の順に入る。`volta` も `code` もこの中で入るので、
   前準備は要らない
3. `volta.txt` から node とグローバルパッケージを入れる（下記「volta 側の復元」）
4. `./install.sh` でシンボリックリンクを張る

### コマンド

```bash
# 復元（新マシン。Brewfile にあって未インストールのものを入れる）
brew bundle install --file=~/dotfiles/Brewfile

# 差分の確認（何が足りないか。インストールはしない）
brew bundle check --file=~/dotfiles/Brewfile --verbose

# 一覧
brew bundle list --file=~/dotfiles/Brewfile
```

### volta 側の復元

`volta.txt` は `volta list all` の生の出力なので、**そのままでは実行できない**。
volta（Brewfile 経由で入る）を入れたあと、awk で抜き出して渡す（`volta.txt` の
先頭にも書いてある）:

```bash
volta install $(awk '$1=="runtime"{print $2}' ~/dotfiles/volta.txt)                  # 全ランタイム
volta install $(awk '/^runtime/ && /\(default\)/{print $2}' ~/dotfiles/volta.txt)   # default を最後に入れ直す
volta install $(awk '$1=="package"{print $2}' ~/dotfiles/volta.txt)                  # グローバルパッケージ
```

`volta install` は `tool[@version]` を複数まとめて受け取れるので、抽出した文字列を
そのまま渡せる（`@mermaid-js/mermaid-cli@11.16.0` のようにバージョン込みで固定される）。

2行目があるのは、`volta install node@X` が**最後に入れたものを default にする**ため。
ランタイムが複数あるときに元の default へ戻す。

**再現されないもの**: `volta.txt` の package 行末尾にある「どの node で入れたか」
（例: `@vue/cli` は node@20.13.1 で入れた）は復元されず、default の node に紐づく。
node ごとに分けたい場合は手で `volta install` し直す。

### 再生成

パッケージを入れた / 消したら、dump を撮り直してコミットする。
先頭のコメント群を残したまま中身だけ入れ替える1行（Brewfile の先頭にも書いてある）:

```bash
{ awk '/^#|^$/{print;next}{exit}' ~/dotfiles/Brewfile; brew bundle dump --file=- --no-npm; } > ~/dotfiles/Brewfile.new && mv ~/dotfiles/Brewfile.new ~/dotfiles/Brewfile
```

volta 側も同じ形（`volta.txt` の先頭にも書いてある）:

```bash
{ awk '/^#|^$/{print;next}{exit}' ~/dotfiles/volta.txt; volta list all --format plain; } > ~/dotfiles/volta.txt.new && mv ~/dotfiles/volta.txt.new ~/dotfiles/volta.txt
```

`awk` は先頭の連続するコメント・空行だけを拾って、最初の実データ行（`tap "..."`）で
`exit` する。`brew bundle dump` 単体で上書きするとヘッダが消えるのでこの形にしている。
再生成しても差分ゼロになることは確認済み。

## 注意

- **`brew bundle cleanup --force` は使わない。** Brewfile に無いものをアンインストールする
  コマンドで、`--no-npm` などで意図的に外している分まで巻き込む。何が消えるかは
  `--force` なしで確認できる
- **dump は警告を出すことがある。** 現状 `libtiff` / `webp` について
  「stale dependency data in installed keg tabs」が出るが、dump 自体は最後まで通る。
  Brewfile の内容には影響しない
- **`.zprofile` の内容（API キー等）とは無関係。** Brewfile はパッケージ名しか持たないので
  コミットしてよい

## 関連

- `utftex` は Neovim で数式を Unicode テキストとして描画するために入れている
  （render-markdown.nvim が変換コマンドとして使う）。消すと数式が素の LaTeX 表示に戻る
