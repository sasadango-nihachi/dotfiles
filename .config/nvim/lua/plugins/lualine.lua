-- statusline に「リポジトリ全体の変更ファイル数」を出す（VSCode の SCM バッジ相当）。
--
-- LazyVim 標準の lualine_x にある `diff`（+12 ~3 -1）は
-- `vim.b.gitsigns_status_dict` が源で、**現在のバッファの行数**しか出ない。
-- gitsigns がグローバルに持つのは `g:gitsigns_head`（ブランチ名）だけで、
-- リポジトリ全体を集計する API は無い（`gitsigns.txt` の b:gitsigns_status_dict の項）。
-- そのため自前で `git status --porcelain` を数える。
--
-- 描画のたびに git を起動すると重いので、値はキャッシュして
-- 変化しうるタイミング（保存・フォーカス復帰・cwd 変更）だけ非同期で更新する。
-- 表示位置は lualine_b の branch の直後＝「リポジトリ全体の話」だと分かる並び。

local Count = {
    n = 0, -- 直近の変更ファイル数
    running = false, -- 多重起動防止
}

-- `git status --porcelain=v1 -z` の出力から件数を数える。
-- -z は NUL 区切り。rename は `XY <new>\0<old>\0` と旧パスが続くが、
-- 旧パスは "XY " の status prefix を持たないためマッチせず、二重に数えない。
function Count.parse(output)
    local n = 0
    for _, entry in ipairs(vim.split(output, "\0")) do
        if entry ~= "" and entry:match("^(..) (.+)$") then
            n = n + 1
        end
    end
    return n
end

function Count.refresh()
    if Count.running then
        return
    end
    local ok, root = pcall(function()
        return Snacks.git.get_root()
    end)
    if not ok or not root then
        Count.n = 0
        return
    end
    Count.running = true
    vim.system({
        "git",
        "--no-pager",
        "--no-optional-locks", -- 他の git 操作と index ロックを取り合わない
        "status",
        "--porcelain=v1",
        "-z",
        -- 未追跡は必ずファイル単位で数える。既定の -unormal だと
        -- 未追跡ディレクトリが `?? dir/` の1件に畳まれ、中に何ファイルあっても
        -- 1 としか数えない（VSCode の SCM バッジはファイル単位なのでズレる）。
        -- .gitignore は引き続き効くので、無視対象が混ざることはない。
        "-uall",
    }, { cwd = root, text = true }, function(out)
        Count.running = false
        Count.n = out.code == 0 and Count.parse(out.stdout or "") or 0
    end)
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufWritePost", "FocusGained", "DirChanged" }, {
    desc = "リポジトリ全体の変更ファイル数を更新",
    callback = function()
        Count.refresh()
    end,
})

return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_b, {
                function()
                    return " " .. Count.n
                end,
                cond = function()
                    return Count.n > 0
                end,
                color = function()
                    return { fg = Snacks.util.color("Special") }
                end,
            })
        end,
    },
}
