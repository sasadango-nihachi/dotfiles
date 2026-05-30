-- 既存 .vimrc の vim-fugitive を維持
-- LazyVim には gitsigns / lazygit が組み込み済みだが、:Git コマンド資産のため fugitive も入れる
return {
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gstatus", "Gdiff", "Gblame", "Glog", "Gcommit", "Gpush", "Gpull" },
    },
}
