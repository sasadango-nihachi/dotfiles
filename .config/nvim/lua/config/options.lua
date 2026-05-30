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
