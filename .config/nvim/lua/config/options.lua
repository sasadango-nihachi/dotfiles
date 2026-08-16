-- LazyVim 起動前に読み込まれる options（lua/config/options.lua は autoload される）
-- LazyVim のデフォルトを上書きしたいものだけ書く

local opt = vim.opt

-- Python を主に書くので 4 spaces を明示
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- 既存 .vimrc から引き継ぎ
opt.autoindent = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildmode = { "list:longest", "full" }
opt.virtualedit = "block"
opt.termguicolors = true
opt.background = "dark"

-- LazyVim デフォルトで有効だが明示しておく
opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"

-- ---------------------------------------------------------------
-- リポジトリ固有の設定を読む（VSCode の .vscode/settings.json 相当）
-- ---------------------------------------------------------------
-- カレントディレクトリの .nvim.lua / .nvimrc / .exrc を読み込む。
-- 例: ~/code/tank/.nvim.lua で Peacock と同じ色をステータスラインに当てる。
--
-- NOTE: 任意の Lua が実行されるため、clone してきた他人のリポジトリでは危険。
--       Neovim は初回読み込み時に信頼を確認し、結果を
--       ~/.local/state/nvim/trust にファイルのハッシュ付きで記録する。
--       内容が変わると再確認が入る。手動管理は :trust / :trust deny / :trust remove。
--       見覚えのないリポジトリでは必ず中身を読んでから許可すること。
opt.exrc = true
