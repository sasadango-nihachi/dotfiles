"use strict";
// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.
module.exports = {
    config: {
        // choose either `'stable'` for receiving highly polished,
        // or `'canary'` for less polished but more frequent updates
        updateChannel: 'stable',
        // default font size in pixels for all tabs
        fontSize: 14,  // 少し大きくして見やすく
        // font family with optional fallbacks
        fontFamily: 'Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
        // default font weight: 'normal' or 'bold'
        fontWeight: 'normal',
        // font weight for bold characters: 'normal' or 'bold'
        fontWeightBold: 'bold',
        // line height as a relative unit
        lineHeight: 1.2,  // 行間を少し広げて読みやすく
        // letter spacing as a relative unit
        letterSpacing: 0.5,  // 文字間隔を少し広げる
        // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
        cursorColor: '#FF5555',  // カーソルの色を明るく
        // terminal text color under BLOCK cursor
        cursorAccentColor: '#000',
        // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
        cursorShape: 'BEAM',  // ビーム型カーソルに変更
        // set to `true` (without backticks and without quotes) for blinking cursor
        cursorBlink: true,  // カーソル点滅を有効化
        // color of the text
        foregroundColor: '#FFFFFF',  // テキストを純白に
        // terminal background color
        // opacity is only supported on macOS
        backgroundColor: 'rgba(0, 0, 0, 0.7)',  // 背景に透明度を追加
        // terminal selection color
        selectionColor: 'rgba(255, 255, 0, 0.3)',  // 選択部分を黄色っぽく
        // border color (window, tabs)
        borderColor: '#333',
        // custom CSS to embed in the main window
        css: '',
        // custom CSS to embed in the terminal window
        termCSS: '',
        // set custom startup directory (must be an absolute path)
        workingDirectory: '',
        // if you're using a Linux setup which show native menus, set to false
        // default: `true` on Linux, `true` on Windows, ignored on macOS
        showHamburgerMenu: '',
        // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
        // additionally, set to `'left'` if you want them on the left, like in Ubuntu
        // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
        showWindowControls: '',
        // custom padding (CSS format, i.e.: `top right bottom left`)
        padding: '14px 16px',  // パディングを少し広げる
        // the full list. if you're going to provide the full color palette,
        // including the 6 x 6 color cubes and the grayscale map, just provide
        // an array here instead of a color map object
        colors: {
            black: '#000000',
            red: '#FF5555',  // ポケモンテーマに合わせた鮮やかな色
            green: '#55FF55',
            yellow: '#FFFF55',
            blue: '#5555FF',
            magenta: '#FF55FF',
            cyan: '#55FFFF',
            white: '#F8F8F2',
            lightBlack: '#686868',
            lightRed: '#FF6E6E',
            lightGreen: '#69FF69',
            lightYellow: '#FFFF69',
            lightBlue: '#6969FF',
            lightMagenta: '#FF69FF',
            lightCyan: '#69FFFF',
            lightWhite: '#FFFFFF',
            limeGreen: '#32CD32',
            lightCoral: '#F08080',
        },
        // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
        // if left empty, your system's login shell will be used by default
        shell: '',
        // for setting shell arguments (i.e. for using interactive shellArgs: `['-i']`)
        // by default `['--login']` will be used
        shellArgs: ['--login'],
        // for environment variables
        env: {},
        // Supported Options:
        //  1. 'SOUND' -> Enables the bell as a sound
        //  2. false: turns off the bell
        bell: 'SOUND',
        // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
        copyOnSelect: true,  // 選択時に自動コピー
        // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
        defaultSSHApp: true,
        // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
        // selection is present (`true` by default on Windows and disables the context menu feature)
        quickEdit: false,
        // choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
        // or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
        // (inside tmux or vim with mouse mode enabled for example).
        macOptionSelectionMode: 'vertical',
        // Whether to use the WebGL renderer. Set it to false to use canvas-based
        // rendering (slower, but supports transparent backgrounds)
        webGLRenderer: false,  // 透明背景のためfalseに変更
        // keypress required for weblink activation: [ctrl|alt|meta|shift]
        // todo: does not pick up config changes automatically, need to restart terminal :/
        webLinksActivationKey: '',
        // if `false` (without backticks and without quotes), Hyper will use ligatures provided by some fonts
        disableLigatures: false,  // リガチャを有効化
        // set to true to disable auto updates
        disableAutoUpdates: false,
        // set to true to enable screen reading apps (like NVDA) to read the contents of the terminal
        screenReaderMode: false,
        // set to true to preserve working directory when creating splits or tabs
        preserveCWD: true,


        // ポケモン設定
        // 使用可能なポケモン一覧（一部）:
        // 第1世代: pikachu（ピカチュウ）, bulbasaur（フシギダネ）, charmander（ヒトカゲ）, squirtle（ゼニガメ）, 
        //         gengar（ゲンガー）, charizard（リザードン）, blastoise（カメックス）, venusaur（フシギバナ）, 
        //         mew（ミュウ）, mewtwo（ミュウツー）, snorlax（カビゴン）, dragonite（カイリュー）
        // 第2世代: totodile（ワニノコ）, cyndaquil（ヒノアラシ）, chikorita（チコリータ）, 
        //         typhlosion（バクフーン）, ampharos（デンリュウ）, lugia（ルギア）, ho-oh（ホウオウ）
        // 第3世代: treecko（キモリ）, torchic（アチャモ）, mudkip（ミズゴロウ）, 
        //         rayquaza（レックウザ）, kyogre（カイオーガ）, groudon（グラードン）
        // 他の世代: lucario（ルカリオ）, greninja（ゲッコウガ）, decidueye（ジュナイパー）, 
        //         lycanroc（ルガルガン）, mimikyu（ミミッキュ）, marshadow（マーシャドー）

        // ポケモン設定
        pokemon: 'pikachu',  // ピカチュウをデフォルトに設定
        pokemonSyntax: 'dark',  // ダークテーマ
        unibody: 'false',  // ポケモンの色に基づく統一テーマ
        // for advanced config flags please refer to https://hyper.is/#cfg
    },
    // a list of plugins to fetch and install from npm
    // format: [@org/]project[#version]
    // examples:
    //   `hyperpower`
    //   `@company/project`
    //   `project#1.0.1`
    plugins: [
        'hyper-pokemon',  // ポケモンテーマプラグイン
        'hyper-opacity',  // 透明度調整用プラグイン
        'hyper-tabs-enhanced'  // タブの機能強化
    ],
    // in development, you can create a directory under
    // `~/.hyper_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: [],
    keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
    },
};
