# jrnl 設定（.config/jrnl/jrnl.yaml）について

管理対象: `~/dotfiles/.config/jrnl` → `~/.config/jrnl`（ディレクトリごとシンボリックリンク）

運用の記録は tank の `~/code/tank/library/journal/README.md`。ここは設定の中身。

---

## ジャーナル本体は Google Drive に置く

```yaml
journals:
  default:
    journal: "~/Library/CloudStorage/GoogleDrive-${JRNL_GDRIVE_EMAIL}/マイドライブ/journal"
```

**ディレクトリを指すとフォルダジャーナル**になり、`YYYY/MM/DD.txt` の日別ファイルで
保存される。1ファイルに追記していく形式と違い、日をまたいだ編集が別ファイルになるので
**クラウド同期の衝突に強い**。

メールアドレスは環境変数 `JRNL_GDRIVE_EMAIL` で注入する（`~/.zprofile` で export）。
アドレスを設定ファイルに直書きせず dotfiles に含めないための措置。

## 暗号化しない

```yaml
encrypt: false
```

**フォルダジャーナルは暗号化できない**（jrnl の仕様）。クラウド上は平文なので、
機密性は Google アカウント側のアクセス制御に依存する。

## その他

| 設定 | 値 |
|---|---|
| `editor` | `vim` |
| `timeformat` | `%Y-%m-%d %H:%M` |
| `linewrap` | 79 |
| `default_hour` / `default_minute` | 9 / 0（時刻を書かずに日付だけ指定したときの既定） |
| `indent_character` | `\|` |
| `tagsymbols` | `@`（既定の `@` のまま。本文中の `@word` がタグになる） |
| `highlight` | true |
| `colors` | body なし / date 黒 / tags 黄 / title シアン |

## 関連

- 全文検索は tank の `scripts/journal_index/`（DuckDB に増分インデックス）→ `/rag-ask`
- 俯瞰は tank の `/mapping` スキルが journal 原文を直読みして行う
