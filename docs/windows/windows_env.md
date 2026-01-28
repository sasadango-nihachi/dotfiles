# Windows環境についてのメモ

## WSL2について

- Ubuntuを入れてる場合
```
wsl --install # installするコマンド

wsl -d Ubuntu

wsl でデフォルトに入る
```

## Chocolateyのインストール

- install command
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

- 確認
```
# バージョン確認
choco --version

# install 例
choco install wezterm

```

- よく使うコマンド
```
choco install <パッケージ>   # インストール
choco unisntall <パッケージ> # アンイストール
choco upgrade all            # 全パッケージを更新
choco list                   # インストール済み一覧
choco serch <キーワード>     # パッケージ検索
```

