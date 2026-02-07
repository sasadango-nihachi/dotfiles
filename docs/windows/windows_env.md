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

## ローカルエリアでネットワーク接続（WiFiの場合）

- 情報取得
    - Ipv4アドレス（ローカル）
    - サブネットマスク
    - デフォルトゲートウェイ
    - DNSサーバー

- コマンド
```
ipconfig /all
```

- 設定手順
    1.「設定」
    2.「ネットワークとインターネット」
    3.「Wi-Fi」をクリック
    4. 接続中のネットワーク名をクリック
    5.「IP割り当て」の「編集」をクリック

## OpenSSH導入

```
# chocoで--paramsをいれないとクライアントしか入らない
choco install openssh --params="/SSHServerFeature"

Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

Get-Service sshd
```

## WSLメモリ制限変更かつIdleTimeoutオフ
- 下記作成
```
vim C:\Users\myuser\.wslconfig
```

- 内容
```
[wsl2]
memory=24GB
vmIdleTimeout=-1
```


