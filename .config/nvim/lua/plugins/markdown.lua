-- Markdown の調整
-- 本体は LazyVim の lang.markdown extra（config/lazy.lua で import）。
-- ここはその上に被せる差分だけを書く。
return {
    -- render-markdown.nvim: バッファ内で見出し・表・コードを装飾表示する。
    -- 別ウィンドウのプレビューではなく、編集しているバッファそのものが装飾されるので
    -- そのまま編集できる（Obsidian の Live Preview と同じモデル）。
    --
    -- 中核は anti-conceal（既定で有効）。カーソルが乗っている行だけ装飾を外して
    -- 生の記法を見せる。Emacs の markdown-mode にはこれが無く、
    -- markdown-hide-markup は全体一括のトグルしか持たない。
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            -- 挿入モードに入ったらバッファ全体を素の markdown に戻す（＝既定の挙動）。
            --
            -- NOTE: ここに入っていないモードでは装飾が一切かからない。
            --       n=ノーマル / c=コマンド / t=ターミナル なので、
            --       i を押した瞬間に生の markdown に戻り、抜けると装飾が戻る。
            --       読む時は装飾・書く時は素、という切り替えになる。
            --
            --       true にすると全モードで装飾を維持し、anti_conceal（既定で有効）が
            --       効いてカーソル行だけ生の記法が出る＝ Obsidian の Live Preview と同じ。
            --       ただし日本語の表は装飾時に罫線がずれやすいので、
            --       編集中は素に戻る方が扱いやすい。公式の preset = 'obsidian' が true 相当。
            render_modes = { "n", "c", "t" },

            -- LazyVim の既定は checkbox.enabled = false。
            -- tank は paper-search / dividend-screening の出力が `- [ ]` のリストなので有効化する。
            checkbox = { enabled = true },
        },
    },

    -- NOTE: 保存時の自動フォーマット停止と spell の無効化は autocmd なので
    --       lua/config/autocmds.lua に置いてある。
    --       プラグインの init に書くと LazyVim の autocmd より先に登録されて
    --       後から潰されるため（LazyVim は「lazyvim を読んでからユーザ設定」の順）。

    -- markdownlint の診断を markdown では出さない。
    --
    -- NOTE: lang.markdown extra は nvim-lint に markdownlint-cli2 を登録する。
    --       これは英語圏の技術文書向けのルールセットで、tank のメモとは前提が合わない。
    --       実際に出るのは MD013/line-length（日本語は1行が長くなるので全段落が該当）と
    --       MD060/table-column-style（`|---|---|` のように区切り行を詰めて書くと全部警告）。
    --       診断は virtual text で本文の右に流れるため、表の中に error 文字列が挿し込まれて
    --       レイアウトが壊れて見える。ルールを個別に切るより丸ごと外す方が早い。
    --
    --       formatters_by_ft と同じく空テーブルでは tbl_deep_extend で消えないので、
    --       opts を関数形式にして明示的に代入する。
    --       markdownlint 自体は残してあるので、必要な時は :!markdownlint-cli2 <file> で叩ける。
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.markdown = {}
            opts.linters_by_ft["markdown.mdx"] = {}
        end,
    },

}
