-- 既存 .vimrc の catppuccin_mocha を Neovim でも採用
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            background = { dark = "mocha" },
            integrations = {
                telescope = true,
                treesitter = true,
                native_lsp = { enabled = true },
                mason = true,
                neotree = true,
                which_key = true,
            },
        },
    },
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "catppuccin-mocha" },
    },
}
