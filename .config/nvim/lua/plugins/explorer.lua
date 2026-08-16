-- ファイルツリー（snacks.explorer / <leader>e）の調整
-- LazyVim 14 以降のツリーは neo-tree ではなく snacks.picker の explorer ソース。
return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    explorer = {
                        -- ドットファイルを最初から表示する。
                        -- tank は .claude/（スキル・エージェント定義・settings.json）が
                        -- 実質の作業対象で、.github/ .obsidian/ .gitignore も触る。
                        -- 既定は false で、ツリー内の H で都度切り替える形だった。
                        hidden = true,

                        -- .git だけは中身が数千ファイルあってツリーが埋まるので常に隠す。
                        -- NOTE: exclude はグロブのリストで、node のフルパスに対して照合される
                        --       （Snacks.picker.util.globber）。".git" だけで
                        --       /path/to/repo/.git にマッチし、.claude 等は巻き込まない。
                        --       hidden の切り替え（H）とは別系統なので、H を押しても出てこない。
                        exclude = { ".git" },

                        -- gitignore 対象は隠したまま（I で一時的に表示できる）。
                        -- tank は rag/*.duckdb や **/repo/ など再生成可能な重いものを
                        -- gitignore しているので、既定で見えない方が扱いやすい。
                        ignored = false,
                    },
                },
            },
        },
    },
}
