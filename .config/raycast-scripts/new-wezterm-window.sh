#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New WezTerm Window
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName WezTerm
# @raycast.icon 🖥️
# @raycast.argument1 { "type": "text", "placeholder": "path", "optional": true }

# Documentation:
# @raycast.description WezTerm を新しいウィンドウで開く（引数でディレクトリ指定可）
# @raycast.author sasadango-nihachi

WEZTERM=/Applications/WezTerm.app/Contents/MacOS/wezterm

DIR="${1:-$HOME}"
# Raycast の引数はクォート済み文字列で渡るため ~ がシェル展開されない。手動で置換する
DIR="${DIR/#\~/$HOME}"
# 存在しないパスを渡すと wezterm が起動に失敗するのでホームに退避
[ -d "$DIR" ] || DIR="$HOME"

if pgrep -x wezterm-gui > /dev/null; then
  # GUI 起動中: 既存インスタンスに新規ウィンドウを生やす（--new-tab を付けるとタブになる）
  "$WEZTERM" start --cwd "$DIR"
else
  # 未起動: そのまま起動
  open -a WezTerm
fi

# Script Command はバックグラウンド実行でフォーカスが移らないため明示的に前面化
open -a WezTerm
