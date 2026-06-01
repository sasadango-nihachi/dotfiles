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

-- :TutorJa  日本語版チュートリアルを開く（ロケール非依存）
-- 使い方: :TutorJa  (1章)  /  :TutorJa 2  (2章)
vim.api.nvim_create_user_command("TutorJa", function(opts)
  local chapter = opts.args ~= "" and opts.args or "01"
  if #chapter == 1 then
    chapter = "0" .. chapter
  end
  local file = vim.env.VIMRUNTIME .. "/tutor/ja/vim-" .. chapter .. "-beginner.tutor"
  if vim.fn.filereadable(file) == 0 then
    vim.notify("Tutor file not found: " .. file, vim.log.levels.ERROR)
    return
  end
  vim.fn["tutor#SetupVim"]()
  vim.cmd("drop " .. vim.fn.fnameescape(file))
  vim.fn["tutor#EnableInteractive"](true)
  vim.fn["tutor#ApplyTransform"]()
end, { nargs = "?", desc = "日本語版 Tutor を開く（引数で章番号、例: :TutorJa 2）" })
