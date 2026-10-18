-- 画像・PDF をバッファで開く（snacks.image / Kitty Graphics Protocol）
--
-- snacks.nvim は LazyVim に同梱されているが image モジュールだけは既定で無効
-- （needs_setup = true）。有効にすると png/jpg/gif/webp/pdf/mp4 等を開いたときに
-- そのバッファ自身に filetype=image が付き、ウィンドウに画像が描画される。
-- VSCode で画像ファイルを開くのと同じで、バッファ一覧にも並ぶし split にも置ける。
--
-- 前提:
--   * 端末が Kitty Graphics Protocol に対応していること（wezterm / ghostty / kitty）
--   * PNG 以外の変換に ImageMagick（magick）が要る。PDF はさらに ghostscript。
--     未インストールでも壊れはせず、単に何も表示されないだけ（convert.notify = false）。
return {
    {
        "folke/snacks.nvim",
        opts = {
            image = {
                enabled = true,

                -- 文書内（markdown 等）の画像・数式の描画は切っておく。
                --
                -- NOTE: 既定は doc.enabled = true だが、これを入れると markdown バッファ全部の
                --       挙動が変わるので分けている。理由は2つ。
                --
                --       1. wezterm はインライン描画（unicode placeholders）に非対応なので
                --          doc.inline が落ちて float 経路になる。この経路は各 markdown バッファに
                --          CursorMoved の autocmd を張り、カーソルが画像リンクや数式の範囲に
                --          入るたびにフロートを開く。tank のメモ編集中は邪魔になる。
                --       2. math.enabled も既定で true。/Library/TeX/texbin/pdflatex が居るので
                --          `$...$` を含む md（library/quant, library/glossary 等）を開くと
                --          実際に pdflatex + magick が走る。
                --
                --       ghostty で読むときはインライン描画が効くので、
                --       そのときは doc = { enabled = true } に戻すとよい。
                --       画像込みの md は EPUB 由来（scripts/epub_to_md の images/）が該当。
                doc = { enabled = false },
            },
        },
    },
}
