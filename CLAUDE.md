# CLAUDE.md

このリポジトリ（dotfiles）で作業するときの指針。

## このリポジトリについて
- 各種設定ファイルを管理し、`$HOME` 直下に配置して使う dotfiles リポジトリ。
- 「リポジトリ内のパス = ホームでのパス」で対応させる方針（`.zshrc` → `~/.zshrc`、`.config/nvim` → `~/.config/nvim`）。
- `install.sh` がシンボリックリンクを張る。既存の実体ファイルは `~/dotfiles_backup/<日時>/` にバックアップされる。

## install.sh の流儀
- `FILES[]` … `~/` 直下に配置するファイル（`.zshrc` など）。
- `CONFIG_DIRS[]` … `~/.config/` 配下に配置するディレクトリ（`nvim` など）。
- 管理対象を増やすときはこれらの配列に追記する。
- `.claude` や `.codex` などは sessions / cache / 認証情報を含むため、ディレクトリ丸ごとはリンクしない。必要な個別ファイルだけを扱う。

## パッケージの記録（Brewfile / volta.txt）
- `Brewfile` に Homebrew の tap / formula / cask と **VS Code 拡張**を、`volta.txt` に **node ランタイムと volta 管理のグローバルパッケージ**を記録する。
- **どちらもコマンドの生成物なので手書きしない。** 再生成コマンドは各ファイルの先頭コメントにある。
- 2枚に分かれているのは、volta が `npm install -g` を横取りするため `brew bundle dump --npm`（`npm ls -g` を見る）が volta のパッケージを取りこぼすから。Brewfile 側は `--no-npm` で npm を外している。
- シンボリックリンクは張らない（`install.sh` の配列に入れない）。`--file` でリポジトリ内の実体を直接指す。
- パッケージを増やした・消したら記録を撮り直す。詳細は [docs/brew/brewfile.md](docs/brew/brewfile.md)。

## docs/ の線引き（tank との分担）

`docs/` には **設定ファイルの実体に紐づく解説だけ**を置く。設定ファイルと 1:1。

**使い方・キー一覧・チートシートは tank リポジトリの memo（`~/code/tank/ideas/memo/` に日付つきで書き、
`library/hub/editor_hub.md` `tools_hub.md` `git_hub.md` から束ねる）** に置く。ここには書かない。

判断基準: 「**設定ファイルを消したらこの文書は無意味になるか**」。
無意味になるなら `docs/`、独立して読めるなら tank。

設定を変えたら、設定の意図は `docs/` に、使い方や調べて分かった仕組みは
tank の memo に書き、該当する hub に1行足す。詳細は [docs/README.md](docs/README.md)。

## 作業上の注意
- 応答は日本語で行う。
- パスは絶対パスをハードコードせず `$HOME` を使う。
- 鍵・認証情報を含むファイル（`.zprofile` など）はコミットしない。
