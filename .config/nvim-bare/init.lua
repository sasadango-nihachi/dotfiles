-- Minimal Neovim config (no plugins, no LazyVim)
-- Purpose: bare Vim/Neovim の挙動確認用の実験室
-- Launch:  NVIM_APPNAME=nvim-bare nvim   (alias: nvb)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indent
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 4
vim.opt.wrap = false

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard (macOSのシステムクリップボードと連携)
vim.opt.clipboard = "unnamedplus"

-- Window splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Undo
vim.opt.undofile = true

-- Force hjkl (矢印キーを物理的に封じる、Vim修行用)
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  vim.keymap.set({ "n", "i", "v" }, key, "<Nop>")
end
