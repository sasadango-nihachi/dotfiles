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

-- === ウィンドウサイズ調整 ===
-- LazyVim 標準は <C-Up>/<C-Down>/<C-Left>/<C-Right> だが、
-- macOS が既定でこの4つを全部握っているため nvim まで届かない。
--   Ctrl+←/→ = 操作スペース（デスクトップ）の移動
--   Ctrl+↑   = Mission Control
--   Ctrl+↓   = アプリケーションウインドウ（App Exposé）
-- システム設定 > キーボード > キーボードショートカット > Mission Control で
-- 解放すれば標準キーも使えるようになるが、デスクトップ切り替えを失う。
-- ここでは macOS 側を触らずに済むよう <leader>w 配下へ逃がす。
-- NOTE: 標準の <C-Up> 等の割当は残してあるので、将来 macOS 側を解放すれば両方使える。
--       Ctrl を使わない素の Vim のキー（10<C-w>> など）や :vert res +10 も衝突しない。
map("n", "<leader>w>", "<cmd>vertical resize +5<cr>", { desc = "幅を広げる" })
map("n", "<leader>w<", "<cmd>vertical resize -5<cr>", { desc = "幅を狭める" })
map("n", "<leader>w+", "<cmd>resize +5<cr>", { desc = "高さを伸ばす" })
map("n", "<leader>w-", "<cmd>resize -5<cr>", { desc = "高さを縮める" })

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

-- ■ 開いているファイルをブラウザで見る（<leader>ch）
--
-- ファイル種別で動作が変わる:
--   markdown  … 単体 HTML にして .tmp/ に出してから開く
--   html/svg  … そのまま開く（生成物の確認用）
--
-- markdown-preview（<leader>cp、LazyVim が markdown に割り当てている）との使い分け:
--   <leader>cp … サーバを立ててブラウザが接続。編集にスクロール追従する。閉じたら消える
--   <leader>ch … ファイルとして .tmp/ に残る。後で開ける・人に渡せる。サーバ不要
--
-- 中身は tank の scripts/md_to_html/run.sh。mermaid / KaTeX / CSS は
-- markdown-preview.nvim 同梱のものをコピーして参照するのでオフラインで開ける。
-- インライン <svg> も素通しする（markdown-it を html=true で動かしている）。
vim.keymap.set("n", "<leader>ch", function()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("ファイルが開かれていません", vim.log.levels.WARN)
        return
    end

    -- html / svg はそのままブラウザへ渡す。
    -- 「生成した HTML をブラウザで見る」用途がこれで同じキーに乗る。
    local ft = vim.bo.filetype
    if ft == "html" or ft == "svg" or file:match("%.html?$") or file:match("%.svg$") then
        vim.system({ "open", file })
        vim.notify("ブラウザで開きました: " .. file)
        return
    end

    if ft ~= "markdown" then
        vim.notify("markdown / html / svg のいずれかで使ってください（現在: " .. ft .. "）", vim.log.levels.WARN)
        return
    end

    local script = vim.fn.expand("~/code/tank/scripts/md_to_html/run.sh")
    if vim.fn.executable(script) == 0 then
        vim.notify("スクリプトが見つかりません: " .. script, vim.log.levels.ERROR)
        return
    end
    vim.notify("HTML を生成中…")
    vim.system({ script, file }, { text = true }, function(res)
        vim.schedule(function()
            if res.code == 0 then
                vim.notify("ブラウザで開きました: " .. vim.trim(res.stdout or ""))
            else
                vim.notify("失敗: " .. vim.trim((res.stderr or "") .. (res.stdout or "")), vim.log.levels.ERROR)
            end
        end)
    end)
end, { desc = "ブラウザで開く（md は HTML 化して / html・svg はそのまま）" })

-- ■ チェックボックス toggle（<CR> / markdown限定）＋ 行内リンクを開く（gx / 全ファイル）
--
-- <CR>（Enter）… markdown バッファ限定。カーソル行の [ ]/[?] ⇄ [x] トグル（フラグ立て）
-- gx          … 全ファイルタイプ（txt / html / markdown …）。カーソル行の最初の http(s)
--               リンクをブラウザで開く。行にURLが無ければカーソル下の <cfile>
--               （URL/ファイルパス）を既定アプリで開く＝標準 gx に近い挙動へフォールバック。
--               ※ render-markdown 等が URL を conceal しても、行テキストから拾うので効く。
--
-- leader 版に切り替えたい場合: 各マップ行をコメントアウトし、直下のコメント例を有効化。

-- カーソル行の [x] ⇄ [ ] をトグル（[?] は [x] にする）。checkbox 行以外は無視。
local function md_toggle_checkbox()
    local l = vim.api.nvim_get_current_line()
    if l:match("%[x%]") then
        l = l:gsub("%[x%]", "[ ]", 1)
    elseif l:match("%[[ ?]%]") then
        l = l:gsub("%[[ ?]%]", "[x]", 1)
    else
        return
    end
    vim.api.nvim_set_current_line(l)
end

-- カーソル行の最初の http(s) リンクをブラウザで開く。無ければ <cfile> にフォールバック。
local function open_link_in_line()
    local l = vim.api.nvim_get_current_line()
    -- markdown の [text](url) を優先、無ければ行内の生 URL（空白・)・引用符・<>・] で止める）
    local url = l:match("%]%((https?://[^)%s]+)%)") or l:match("(https?://[^%s)\"'<>%]]+)")
    if url then
        vim.ui.open(url)
        return
    end
    -- 行にURLが無ければ、カーソル下の <cfile>（URL/存在するファイル・ディレクトリ）を開く
    local cfile = vim.fn.expand("<cfile>")
    if cfile ~= "" and (cfile:match("^%w+://") or cfile:match("^www%.")
        or vim.fn.filereadable(cfile) == 1 or vim.fn.isdirectory(cfile) == 1) then
        vim.ui.open(cfile)
    else
        vim.notify("この行にリンクがありません", vim.log.levels.WARN)
    end
end

-- gx は全ファイルタイプでグローバルに張る（plugin が buffer-local gx を持つバッファでは
-- そちらが優先されるので邪魔しない）。
vim.keymap.set("n", "gx", open_link_in_line,
    { silent = true, desc = "行内リンク or カーソル下をブラウザで開く" })
-- leader 版にするなら上をコメントアウトして下を有効化:
-- vim.keymap.set("n", "<leader>mo", open_link_in_line,
--     { silent = true, desc = "行内リンクをブラウザで開く" })

-- <CR> の checkbox トグルは markdown だけに buffer-local で張る
local function set_md_maps(buf)
    vim.keymap.set("n", "<CR>", md_toggle_checkbox,
        { buffer = buf, silent = true, desc = "チェックボックス toggle [x]" })
    -- leader 版にするなら上をコメントアウトして下を有効化:
    -- vim.keymap.set("n", "<leader>mx", md_toggle_checkbox,
    --     { buffer = buf, silent = true, desc = "チェックボックス toggle [x]" })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_markdown_checkbox", { clear = true }),
    pattern = { "markdown", "markdown.mdx" },
    callback = function(ev) set_md_maps(ev.buf) end,
})

-- 起動時に開いたファイルは FileType が keymaps.lua ロード（VeryLazy）より前に発火して
-- 取りこぼすため、既に読み込み済みの markdown バッファへ即適用する。
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
        set_md_maps(buf)
    end
end
