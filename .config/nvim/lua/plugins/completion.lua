-- 補完（blink.cmp）の調整。
-- LazyVim 標準の補完エンジンは blink.cmp。既定では打鍵するたびに候補メニューが
-- 自動で開き、薄いインライン候補（ghost text）も出る。これが「勝手に推奨文字列が
-- 出てきて邪魔」の正体。
--
-- ここでは【補完自体は残しつつ、自動ポップアップだけ止める】。
--   ・menu.auto_show      = false … 打鍵中に自動でメニューを出さない
--   ・ghost_text.enabled  = false … インラインの薄い候補も出さない
-- 補完が欲しいときは <C-Space> で手動で出せる（候補が要らないなら Esc で消える）。
--
-- ▼ 完全に無効化したい（LSP候補も一切出さない）場合は上の opts を消して、
--   代わりに `enabled = false` だけにする:
--     return { "saghen/blink.cmp", enabled = false }
--   ※ その場合スニペット展開や補完によるLSP連携も無くなる。
--
-- ▼ 元に戻す（LazyVim 標準の自動補完に戻す）ときは、このファイルごと削除すればよい。
return {
    "saghen/blink.cmp",
    opts = {
        completion = {
            menu = { auto_show = false },
            ghost_text = { enabled = false },
        },
    },
}
