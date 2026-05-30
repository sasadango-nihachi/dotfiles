-- bootstrap lazy.nvim (LazyVim 公式の推奨パターン)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- LazyVim 本体（推奨プラグイン一式とデフォルトキーマップ）
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- LazyVim Extras（任意の追加機能）
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.terraform" },
        { import = "lazyvim.plugins.extras.lang.docker" },

        -- 自前プラグイン定義
        { import = "plugins" },
    },
    defaults = { lazy = false, version = false },
    install = { colorscheme = { "catppuccin-mocha", "tokyonight" } },
    checker = { enabled = true, notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
