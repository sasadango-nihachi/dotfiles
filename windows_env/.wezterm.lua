local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- フォント設定を追加
-- config.font = wezterm.font('HackGen Console NF')
config.font_size = 10


config.default_prog = {'powershell.exe'}

-- 基本設定
-- config.font_size = 14
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'HaX0R_GR33N'

-- config.color_scheme = 'Dracula'
-- config.window_background_opacity = 0.88
-- config.macos_window_background_blur = 25

-- config.color_scheme = 'Apple Classic'
config.color_scheme = 'Homebrew'
-- config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Kanagawa Dragon (Gogh)'
config.window_background_opacity = 0.85


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

return config
