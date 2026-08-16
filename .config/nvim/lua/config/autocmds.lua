-- LazyVim 標準の autocmds の「後に」読み込まれるファイル。
-- lazyvim/config/init.lua の M.load が "always load lazyvim, then user file" の順で
-- require するため、ここに書いた autocmd は LazyVim のものより後に登録される。
--
-- NOTE: 同じイベント・同じパターンの autocmd は登録順に発火する。
--       つまり LazyVim の設定を上書きしたい場合、プラグインの init に書くと
--       LazyVim より先に走って後から潰されるので効かない。ここに置くこと。

-- ---------------------------------------------------------------
-- Markdown: 赤い波線（spell の undercurl）を止める
-- ---------------------------------------------------------------
-- 波線の出どころは LazyVim の wrap_spell autocmd。
-- markdown / text / gitcommit で vim.opt_local.spell = true を立てている。
--
-- 波線には2種類あり、原因が違う。
--   1. 日本語に出る -> spelllang が en だけなので全部 SpellBad になる。
--                     "cjk" を足すと東アジアの文字が綴り判定から外れて消える。
--   2. 英単語に出る -> 辞書に無い語が SpellBad になる。実測では
--                     md / mdt / nvim / wikilink / gitignore はいずれも SpellBad、
--                     brew / Markdown は辞書にあるので出ない。
--
-- tank のメモはこの手の技術語が本文の主役なので、2 は語を足しても切りが無い。
-- markdown / text では spell 自体を切る。
-- gitcommit は英語の散文を書く場所なので spell を残し、日本語向けに cjk だけ足す。
--
-- spell を残したまま個別に許容したい場合は、その語の上で zg を押すと
-- ~/.config/nvim/spell/ の個人辞書に追加される（zw で除外、z= で候補表示）。
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_markdown_spell", { clear = true }),
    pattern = { "markdown", "markdown.mdx", "text" },
    callback = function()
        vim.opt_local.spell = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_gitcommit_spell", { clear = true }),
    pattern = { "gitcommit" },
    callback = function()
        vim.opt_local.spelllang = { "en", "cjk" }
    end,
})

-- ---------------------------------------------------------------
-- Markdown: 保存時の自動フォーマットを止める
-- ---------------------------------------------------------------
-- LazyVim は vim.g.autoformat = true が既定で、lang.markdown extra は
-- formatters_by_ft.markdown に prettier / markdownlint-cli2 / markdown-toc を登録する。
-- そのままだと tank のメモを開いて :w した時点で prettier が全文を整形し直し、
-- 日本語混じりの表・手で揃えた改行位置・箇条書きの記号が書き換わる。
--
-- conform の formatters_by_ft を空リストで上書きしようとしても
-- LazyVim の opts マージは vim.tbl_deep_extend なので空テーブルでは消えない。
-- format 判定はバッファローカルの vim.b.autoformat を見るのでそちらを落とす。
-- 状態は :LazyFormatInfo で確認できる。整形したい時は明示的に :Format を叩く。
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_markdown_noformat", { clear = true }),
    pattern = { "markdown", "markdown.mdx" },
    callback = function()
        vim.b.autoformat = false
    end,
})
