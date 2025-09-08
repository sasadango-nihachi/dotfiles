# wizterm install mac

- brewでinstall 
```
brew install --cask wezterm
```

- 設定ファイル
```
touch ~/.wezterm.lua

# 最低限の設定
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 基本設定
config.font_size = 14
config.color_scheme = 'Tokyo Night'

return config

```

- 基本的なタブ操作

```
# デフォルトのキーバインド
Cmd+T         # 新しいタブを開く
Cmd+W         # タブを閉じる
Cmd+数字      # タブ番号で切り替え（Cmd+1, Cmd+2...）
Cmd+Shift+[   # 前のタブへ
Cmd+Shift+]   # 次のタブへ
```

- カスタム設定
```
-- ~/.wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ===========================================
-- タブバーの外観設定
-- ===========================================
-- タブが1つだけの時はタブバーを隠す（画面を広く使える）
config.hide_tab_bar_if_only_one_tab = true

-- タブバーを画面上部に表示（false = 上、true = 下）
config.tab_bar_at_bottom = false

-- macOS風の見た目のタブバー（false にするとシンプルなテキストタブ）
config.use_fancy_tab_bar = true

-- 各タブの最大幅を25文字に制限（長いタイトルは省略される）
config.tab_max_width = 25

-- タブに番号を表示（例: 1: zsh, 2: vim など）
config.show_tab_index_in_tab_bar = true

-- タブを閉じた時、直前にアクティブだったタブに戻る
config.switch_to_last_active_tab_when_closing_tab = true

-- ===========================================
-- ペイン（分割）の外観設定
-- ===========================================
config.inactive_pane_hsb = {
  saturation = 0.8,  -- 非アクティブペインの彩度を80%に（薄くなる）
  brightness = 0.7,  -- 非アクティブペインの明度を70%に（暗くなる）
  -- → 結果: フォーカスしていないペインが暗く表示され、作業中のペインが分かりやすくなる
}

-- マウスオーバーでペインを自動選択（マウスを動かすだけでペインが切り替わる）
config.pane_focus_follows_mouse = true

-- ウィンドウの内側余白（ペインとウィンドウ枠の間のスペース）
config.window_padding = {
  left = 5,    -- 左に5ピクセルの余白
  right = 5,   -- 右に5ピクセルの余白
  top = 5,     -- 上に5ピクセルの余白
  bottom = 5,  -- 下に5ピクセルの余白
}

-- ===========================================
-- キーバインディング設定
-- ===========================================
config.keys = {
  -- ===== タブ操作 =====
  
  -- 【Cmd+T】新規タブを開く
  -- → 結果: 現在のディレクトリで新しいタブが開く
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  
  -- 【Cmd+Shift+T】デフォルトディレクトリで新規タブ
  -- → 結果: ホームディレクトリで新しいタブが開く
  { key = 't', mods = 'CMD|SHIFT', action = act.SpawnTab 'DefaultDomain' },
  
  -- 【Cmd+W】現在のタブを閉じる（確認ダイアログあり）
  -- → 結果: 「本当に閉じますか？」と確認後、タブが閉じる
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
  
  -- 【Cmd+Shift+[】前のタブに移動
  -- → 結果: 左隣のタブに切り替わる（最初のタブなら最後のタブへ）
  { key = '[', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  
  -- 【Cmd+Shift+]】次のタブに移動
  -- → 結果: 右隣のタブに切り替わる（最後のタブなら最初のタブへ）
  { key = ']', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  
  -- 【Ctrl+Tab】次のタブへ（ブラウザ風）
  -- → 結果: 右隣のタブに切り替わる
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  
  -- 【Ctrl+Shift+Tab】前のタブへ（ブラウザ風）
  -- → 結果: 左隣のタブに切り替わる
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  
  -- 【Cmd+Shift+<】タブを左に移動
  -- → 結果: 現在のタブの位置が左に1つ移動する
  { key = '<', mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
  
  -- 【Cmd+Shift+>】タブを右に移動
  -- → 結果: 現在のタブの位置が右に1つ移動する
  { key = '>', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },
  
  -- 【Cmd+Shift+L】最後に使ったタブへジャンプ
  -- → 結果: 直前にアクティブだったタブに瞬時に切り替わる
  { key = 'l', mods = 'CMD|SHIFT', action = act.ActivateLastTab },
  
  -- ===== ペイン分割 =====
  
  -- 【Cmd+D】水平分割（左右に分割）
  -- → 結果: 現在のペインが左右2つに分かれる
  -- → 画面: [元のペイン | 新しいペイン]
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  
  -- 【Cmd+Shift+|】水平分割（別の方法）
  -- → 結果: 同上（覚えやすい記号: | は縦線なので左右分割）
  { key = '|', mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  
  -- 【Cmd+Shift+D】垂直分割（上下に分割）
  -- → 結果: 現在のペインが上下2つに分かれる
  -- → 画面: [元のペイン]
  --         [新しいペイン]
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- 【Cmd+-】垂直分割（別の方法）
  -- → 結果: 同上（覚えやすい記号: - は横線なので上下分割）
  { key = '-', mods = 'CMD', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- ===== ペイン間の移動 =====
  
  -- 【Option+←】左のペインに移動
  -- → 結果: カーソルが左のペインに移り、そのペインがアクティブになる
  { key = 'LeftArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Left' },
  
  -- 【Option+→】右のペインに移動
  -- → 結果: カーソルが右のペインに移る
  { key = 'RightArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Right' },
  
  -- 【Option+↑】上のペインに移動
  -- → 結果: カーソルが上のペインに移る
  { key = 'UpArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Up' },
  
  -- 【Option+↓】下のペインに移動
  -- → 結果: カーソルが下のペインに移る
  { key = 'DownArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Down' },
  
  -- 【Cmd+Shift+H】左のペインに移動（Vim風）
  -- → 結果: Vimのhjklと同じ感覚で左に移動
  { key = 'h', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
  
  -- 【Cmd+Shift+J】下のペインに移動（Vim風）
  -- → 結果: Vimのhjklと同じ感覚で下に移動
  { key = 'j', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },
  
  -- 【Cmd+Shift+K】上のペインに移動（Vim風）
  -- → 結果: Vimのhjklと同じ感覚で上に移動
  { key = 'k', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
  
  -- 【Cmd+Shift+L】右のペインに移動（Vim風）
  -- → 結果: Vimのhjklと同じ感覚で右に移動
  { key = 'l', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
  
  -- 【Cmd+[】前のペインに移動（作成順）
  -- → 結果: ペインを作成した順番で前のペインに移動
  { key = '[', mods = 'CMD', action = act.ActivatePaneDirection 'Prev' },
  
  -- 【Cmd+]】次のペインに移動（作成順）
  -- → 結果: ペインを作成した順番で次のペインに移動
  { key = ']', mods = 'CMD', action = act.ActivatePaneDirection 'Next' },
  
  -- ===== ペインサイズ調整 =====
  
  -- 【Cmd+Option+←】ペインの左境界を左に5ピクセル移動
  -- → 結果: 現在のペインの幅が狭くなる
  { key = 'LeftArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Left', 5 } },
  
  -- 【Cmd+Option+→】ペインの右境界を右に5ピクセル移動
  -- → 結果: 現在のペインの幅が広くなる
  { key = 'RightArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Right', 5 } },
  
  -- 【Cmd+Option+↑】ペインの上境界を上に5ピクセル移動
  -- → 結果: 現在のペインの高さが狭くなる
  { key = 'UpArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Up', 5 } },
  
  -- 【Cmd+Option+↓】ペインの下境界を下に5ピクセル移動
  -- → 結果: 現在のペインの高さが広くなる
  { key = 'DownArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Down', 5 } },
  
  -- ===== ペイン操作 =====
  
  -- 【Cmd+Shift+W】現在のペインを閉じる（確認あり）
  -- → 結果: 「本当に閉じますか？」と確認後、ペインが閉じる
  -- → 残りのペインが自動的にリサイズされる
  { key = 'w', mods = 'CMD|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  
  -- 【Cmd+X】現在のペインを即座に閉じる（確認なし）
  -- → 結果: 確認なしでペインが閉じる（素早い操作向け）
  { key = 'x', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
  
  -- 【Cmd+Shift+Z】ペインをズーム（最大化）トグル
  -- → 結果: ペインが画面全体に広がる ⇔ 元のサイズに戻る
  -- → 使用例: 一時的にペインを大きくして作業したい時
  { key = 'z', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  
  -- 【Cmd+Shift+Enter】ペインをズーム（別のキー）
  -- → 結果: 同上（フルスクリーン感覚で使える）
  { key = 'Enter', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  
  -- 【Cmd+Shift+!】ペインを新しいタブに移動
  -- → 結果: 現在のペインが新しいタブとして独立する
  { key = '!', mods = 'CMD|SHIFT', action = act.PaneSelect { mode = 'MoveToNewTab' } },
  
  -- 【Cmd+Shift+R】ペインを時計回りに回転
  -- → 結果: すべてのペインの位置が時計回りに入れ替わる
  { key = 'r', mods = 'CMD|SHIFT', action = act.RotatePanes 'Clockwise' },
  
  -- 【Cmd+Option+R】ペインを反時計回りに回転
  -- → 結果: すべてのペインの位置が反時計回りに入れ替わる
  { key = 'r', mods = 'CMD|OPT', action = act.RotatePanes 'CounterClockwise' },
  
  -- 【Cmd+Shift+P】ペイン選択モード
  -- → 結果: 各ペインに番号が表示され、番号キーで選択できる
  { key = 'p', mods = 'CMD|SHIFT', action = act.PaneSelect },
  
  -- 【Cmd+Shift+S】ペインを入れ替えモード
  -- → 結果: 番号を選んで現在のペインと位置を入れ替える
  { key = 's', mods = 'CMD|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
  
  -- ===== その他の便利機能 =====
  
  -- 【Cmd+Shift+P】コマンドパレット
  -- → 結果: すべてのコマンドを検索・実行できるメニューが開く
  { key = 'P', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
  
  -- 【Cmd+F】検索モード
  -- → 結果: ペイン内のテキストを検索できる
  { key = 'f', mods = 'CMD', action = act.Search { CaseSensitiveString = '' } },
  
  -- 【Cmd+K】画面クリア
  -- → 結果: スクロールバックバッファと画面表示をクリア
  { key = 'k', mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport' },
}

-- ===== タブ番号でのダイレクト切り替え =====
-- 【Cmd+1〜9】タブを番号で直接選択
-- → 結果: Cmd+1で1番目のタブ、Cmd+2で2番目のタブに即座に切り替わる
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CMD',
    action = act.ActivateTab(i - 1),  -- 0ベースなので-1
  })
end

-- ===========================================
-- tmux風のリーダーキー設定（オプション）
-- ===========================================
-- 【Ctrl+B】を押してから別のキーを押すスタイル
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

-- リーダーキーを使った操作の追加
config.keys = vim.list_extend(config.keys, {
  -- 【Ctrl+B → C】新規タブ（tmux風）
  -- → 結果: tmuxと同じ操作感で新規タブが開く
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  
  -- 【Ctrl+B → |】水平分割（tmux風）
  -- → 結果: tmuxと同じ操作感で左右分割
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  
  -- 【Ctrl+B → -】垂直分割（tmux風）
  -- → 結果: tmuxと同じ操作感で上下分割
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- 【Ctrl+B → Z】ズーム切り替え（tmux風）
  -- → 結果: tmuxと同じ操作感でペインを最大化
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
})

return config
```


- 透過設定
```
-- 軽い透過（ほんのり透ける）
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- 中程度の透過（バランス良い）
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

-- 強い透過（背景がよく見える）
config.window_background_opacity = 0.75
config.macos_window_background_blur = 30

-- ガラス風エフェクト
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
```

- theme
```
色々あるけどhomebrewテーマで落ち着きそう
```

# 現行の設定

```
-- ~/.wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- 基本設定
config.font_size = 14
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'HaX0R_GR33N'

-- config.color_scheme = 'Dracula'
-- config.window_background_opacity = 0.88
-- config.macos_window_background_blur = 25

-- config.color_scheme = 'Apple Classic'
config.color_scheme = 'Homebrew'
-- config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Kanagawa Dragon (Gogh)'
config.window_background_opacity = 0.65
config.macos_window_background_blur = 10

-- ===========================================
-- tmux風のリーダーキー設定（オプション）
-- ===========================================

-- リーダーキー設定
-- 3秒以内に押す
config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 3000 }

config.keys = {
  -- ペイン分割
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- より直感的な分割（追加オプション）
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペイン間の移動
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- 矢印キーでも移動可能
  { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- ペインのサイズ調整
  { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },

  -- その他のtmux風操作
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'o', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'q', mods = 'LEADER', action = act.PaneSelect },

  -- タブ切り替え
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  -- 必要に応じて3-9も追加
}


```