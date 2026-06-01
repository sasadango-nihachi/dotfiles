-- LazyVim 起動前に読み込まれる keymaps（lua/config/keymaps.lua は autoload される）
-- LazyVim のデフォルトキーマップに追加・上書きしたいものだけ書く

local map = vim.keymap.set

-- Leader は LazyVim 標準の <Space> を採用（既存 .vimrc は ',' だったが
-- LazyVim の公式ドキュメント・チュートリアルが全て <Space> 前提のため）
-- ',' に戻したい場合は init.lua より前に下記を設定:
--   vim.g.mapleader = ","
--   vim.g.maplocalleader = ","

-- === ペイン移動（既存 .vimrc 由来） ===
-- LazyVim デフォルトで <C-h/j/k/l> はペイン移動に割当済み。
-- vim-tmux-navigator と統合させたい場合は plugins/tmux.lua を追加する。

-- === ターミナル（既存 .vimrc の :T / :VT / <Leader>t を再現） ===
vim.api.nvim_create_user_command("T", function(opts)
    vim.cmd("botright 10split | terminal " .. (opts.args or ""))
end, { nargs = "*", desc = "下部に高さ10行でターミナルを開く" })

vim.api.nvim_create_user_command("VT", function(opts)
    vim.cmd("vsplit | terminal " .. (opts.args or ""))
end, { nargs = "*", desc = "右側に垂直分割でターミナルを開く" })

-- ターミナルモードから他ペインへ移動（既存 .vimrc 由来）
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "ターミナル → ノーマルモード" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "ターミナルから左へ" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "ターミナルから下へ" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "ターミナルから上へ" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "ターミナルから右へ" })

-- === Git（既存 .vimrc の :GS を再現） ===
-- fugitive プラグインは plugins/git.lua で有効化
vim.api.nvim_create_user_command("GS", function()
    vim.cmd("Git | resize 15")
end, { desc = "Git status を高さ15行で開く" })

-- === 日本語版 Tutor ===
-- `:Tutor` はシェルロケール（v:lang）を見て言語を決めるため、英語ロケールでは英語版が開く。
-- ロケール非依存に日本語版を開くため、tutor.vim 内部処理を直接呼ぶラッパーを定義。
-- 使い方: :TutorJa  (1章を開く)  /  :TutorJa 2  (2章を開く)
vim.api.nvim_create_user_command("TutorJa", function(opts)
    local chapter = opts.args ~= "" and opts.args or "01"
    -- "1" → "01" のように2桁にゼロ埋め
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
