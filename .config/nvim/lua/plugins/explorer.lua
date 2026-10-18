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

                        -- 中身が膨大で開く用のないものは常に隠す。
                        -- NOTE: exclude はグロブのリストで、node のフルパスに対して照合される
                        --       （Snacks.picker.util.globber）。".git" だけで
                        --       /path/to/repo/.git にマッチし、.claude 等は巻き込まない。
                        --       hidden / ignored の切り替え（H / I）とは別系統なので、
                        --       押しても出てこない。
                        exclude = {
                            ".git",
                            ".obsidian", -- Obsidian の UI 状態。読む用途がない
                            "repo", -- shelf/code-reading/<name>/repo（解析対象のクローン本体）
                            ".playwright-cache", -- tech-summary の Chromium（約300MB）
                            "__pycache__",
                            ".DS_Store",
                            "node_modules",
                        },

                        -- gitignore 対象も表示する。
                        -- 既定（false）だと **.tmp/（作業場）と finance/gdrive（GDrive への symlink）
                        -- がツリーから消えてしまう**。どちらも実際に開きたいので出す。
                        -- 重いもの（rag/*.duckdb・repo/・playwright-cache）は上の exclude で
                        -- 個別に落としているので、true にしてもツリーは埋まらない。
                        ignored = true,
                    },
                },
            },
        },
    },
}
