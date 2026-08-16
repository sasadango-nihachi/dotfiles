;;; init.el --- Emacs personal configuration -*- lexical-binding: t; -*-

;;; ---------------------------------------------------------------
;;; パッケージ管理（自己ブートストラップ）
;;; ---------------------------------------------------------------
;; 新しい環境でも、この init.el を置いて Emacs を起動するだけで
;; 必要なパッケージとフォントが自動で揃うようにしてある。

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defvar my/required-packages
  '(nerd-icons
    doom-modeline
    nerd-icons-dired
    nerd-icons-completion
    treemacs
    treemacs-nerd-icons
    diff-hl
    magit
    treemacs-magit
    eat
    exec-path-from-shell
    markdown-mode)
  "この設定が前提とするパッケージ。起動時に未導入なら自動で入れる。")

(defun my/ensure-packages ()
  "MY/REQUIRED-PACKAGES のうち未導入のものをインストールする。"
  (let ((missing (seq-remove #'package-installed-p my/required-packages)))
    (when missing
      (message "[init] 未導入パッケージを取得します: %s" missing)
      ;; アーカイブ情報が未取得のときだけ refresh する（毎回やると起動が遅い）
      (unless package-archive-contents
        (package-refresh-contents))
      (dolist (pkg missing)
        (condition-case err
            (package-install pkg)
          (error (message "[init] %s のインストールに失敗: %s" pkg err)))))))

(my/ensure-packages)

;;; ---------------------------------------------------------------
;;; 起動時の挙動
;;; ---------------------------------------------------------------

;; 起動時のスプラッシュ画面を出さない
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; *scratch* バッファの冒頭コメントを消す
(setq initial-scratch-message nil)

;;; ---------------------------------------------------------------
;;; UI 部品の整理
;;; ---------------------------------------------------------------
;; ツールバーの実体は etc/images/ の xpm/pbm ビットマップ（90年代の素材）で、
;; nerd-icons のアイコンと世代が合わないため消す。
;; スクロールバーも同様。位置はモードラインに出るので実用上困らない。

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;; ---------------------------------------------------------------
;;; フォント
;;; ---------------------------------------------------------------
;; HackGen Console NF = 日本語対応 + Nerd Font パッチ済み。
;; これを既定にするとアイコンが別フォントへフォールバックせず安定して描画される。
;; 無い環境（別マシン等）ではそのまま既定フォントを使う。

(let ((font "HackGen Console NF"))
  (when (and (display-graphic-p) (find-font (font-spec :name font)))
    (set-face-attribute 'default nil :family font :height 140)))

;;; ---------------------------------------------------------------
;;; テーマ（エディタ本体の配色）
;;; ---------------------------------------------------------------

;; Emacs 同梱の misterioso をベースに、背景だけ黒系へ上書きする。
;; misterioso のシンタックスは緑 #74af68 / シアン #00ede1 #34cae2 に加えて
;; 橙 #ffad29 #e67128 を持つので、黒背景なら外枠の琥珀とも繋がる。
;; 背景の上書きは my/apply-peacock-chrome 側で行う（テーマ再読込でも維持されるため）。
(load-theme 'misterioso t)

;;; ---------------------------------------------------------------
;;; アイコン（nerd-icons + doom-modeline）
;;; ---------------------------------------------------------------

(require 'nerd-icons)

;; アイコン用フォントが無いと全部が豆腐(□)になるため、無ければ自動で入れる。
;; GUI 起動時のみ（端末では find-font が使えない）。手動なら M-x nerd-icons-install-fonts
(when (and (display-graphic-p)
           (not (find-font (font-spec :name nerd-icons-font-family))))
  (message "[init] Nerd Font が見つからないためインストールします")
  (nerd-icons-install-fonts t))   ; t = 確認プロンプトを出さない

;; モードライン
(require 'doom-modeline)
(setq doom-modeline-height 28
      doom-modeline-icon t                 ; アイコンを出す
      doom-modeline-major-mode-icon t
      doom-modeline-buffer-file-name-style 'truncate-upto-project
      doom-modeline-minor-modes nil)
(doom-modeline-mode 1)

;; dired のファイル一覧にアイコン
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)

;; 補完候補にアイコン
(require 'nerd-icons-completion)
(nerd-icons-completion-mode 1)

;;; ---------------------------------------------------------------
;;; ファイルツリー（treemacs = VSCode の Explorer 相当）
;;; ---------------------------------------------------------------

(require 'treemacs)

(setq treemacs-width 55
      treemacs-position 'left
      treemacs-indentation 2
      treemacs-show-hidden-files t         ; ドットファイルを表示する
      treemacs-width-is-initially-locked nil ; マウスで幅を変えられるようにする
      treemacs-follow-after-init t)       ; 開いているファイルの位置にツリーを追随させる

;; NOTE: treemacs の既定は幅ロック（t）で、マウスドラッグでは変わらない。
;;       解除しても掴む場所には注意が要る。ドラッグの開始点がフリンジだと
;;       <left-fringe> <drag-mouse-1> という別イベントになり「undefined」で終わる
;;       （treemacs が持つのは [drag-mouse-1] だけ）。
;;       左フリンジは diff-hl のために 16px に広げてあるので特に当たりやすい。
;;       掴むのはツリーと編集画面の間の境界線（window-divider）の方。
;;       キーで変えるなら w（数値指定）/ > / < / = 、一時的なロック解除は t w。

;; NOTE: 隠しファイルを出す理由は .claude/ が実質の作業対象だから
;;       （スキル定義・エージェント定義・settings.json）。
;;       .github/ .obsidian/ .gitignore なども同様に触る対象。
;;       バッファ内で t h (treemacs-toggle-show-dotfiles) で一時的に切り替えできる。

;; ただし .git だけは中身が数千ファイルあって邪魔なので常に隠す。
;; treemacs-show-hidden-files とは別系統で、ignored は「絶対に出さない」枠。
;; NOTE: 既定値には . / .. / ロックファイル等を弾く述語が入っているので
;;       setq で置き換えず add-to-list で足すこと。
(defun my/treemacs-ignore-git-dir (file _path)
  (string= file ".git"))
(add-to-list 'treemacs-ignored-file-predicates #'my/treemacs-ignore-git-dir)

(treemacs-follow-mode 1)      ; カーソルのあるバッファをツリー側で自動追跡
(treemacs-filewatch-mode 1)   ; ファイルの増減を検知してツリーを自動更新
(treemacs-git-mode 'simple)   ; git の状態でファイル名を色分け（git コマンドのみ使用）

;; アイコンを nerd-icons に揃える（既定はビットマップ画像）
(require 'treemacs-nerd-icons)
(treemacs-load-theme "nerd-icons")

;; キーバインド
;; NOTE: treemacs 公式が薦める "C-x t ..." は tab-bar のプレフィックスと衝突する
;;       （C-x t 1 = tab-close-other, C-x t d = dired-other-tab 等が既定で存在する）。
;;       C-c <文字> は利用者用に予約された領域なのでそちらを使う。
(global-set-key (kbd "C-c t") #'treemacs)                ; 開閉
(global-set-key (kbd "C-c T") #'treemacs-select-window)  ; ツリーへカーソル移動

;;; ---------------------------------------------------------------
;;; エディタタブ（VSCode の editor tabs = ✕ ボタン付きのファイルタブ）
;;; ---------------------------------------------------------------
;; NOTE: tab-bar と tab-line は別物。
;;   tab-bar  = フレーム全体のワークスペース切り替え（VSCode のウィンドウに近い）
;;   tab-line = 各ウィンドウの上端に、そこで開いたバッファを並べる（VSCode のタブ）
;; 欲しいのは後者。Emacs 27 から同梱で、✕ ボタンも標準で付く。

(require 'tab-line)

(setq tab-line-close-button-show t          ; タブに ✕ を出す
      tab-line-new-button-show nil          ; + は不要（C-x C-f で開くため）
      tab-line-separator " "
      ;; 既定の bury-buffer は「タブから消えるがバッファは残る」。
      ;; VSCode の ✕ と同じ「閉じる」にする。
      tab-line-close-tab-function #'kill-buffer)

;; サイドウィンドウ（treemacs / eat）にはタブを出さない
(dolist (mode '(treemacs-mode eat-mode))
  (add-to-list 'tab-line-exclude-modes mode))

(global-tab-line-mode 1)

;; キーボードから閉じる / 移動する
(global-set-key (kbd "C-c x")       #'kill-current-buffer)   ; VSCode の Ctrl+W 相当
(global-set-key (kbd "C-c <tab>")   #'tab-line-switch-to-next-tab)
(global-set-key (kbd "C-c S-<tab>") #'tab-line-switch-to-prev-tab)

;;; ---------------------------------------------------------------
;;; UI の配色（VSCode Peacock 相当: 外枠だけを塗る）
;;; ---------------------------------------------------------------
;; パレット
;;   #8B0000 深紅（statusBar 背景）      #E8A24A 琥珀（前景）
;;   #C17A30 濃い琥珀（アクティブ/境界） #1A0A00 ほぼ黒の焦茶（activityBar 背景）
;;   #5E0400 / #96652C はアルファ 0x99(60%) を #1A0A00 上で合成した不透明色
;;   （Emacs のフェイスは透明度を持てないため事前合成が必要）
;;
;; テーマ読み込みより後に置くこと（後勝ちで上書きするため）。

(defun my/apply-peacock-chrome ()
  "VSCode Peacock 風の配色を UI の外枠に適用する。"
  ;; エディタ本体の背景を黒系へ。misterioso 既定の #2d3743（青灰）だと
  ;; 外枠の暖色と分離して見えるため。純黒(#000000)はきついので少しだけ持ち上げる。
  (set-face-attribute 'default nil :background "#0D0D0D")
  ;; 背景を変えたことで浮く箇所を合わせ直す
  (set-face-attribute 'region nil :background "#2d4948")
  (set-face-attribute 'hl-line nil :background "#1a1a1a" :inherit 'unspecified)

  ;; モードライン = VSCode の statusBar
  (set-face-attribute 'mode-line nil
                      :background "#8B0000" :foreground "#E8A24A"
                      :box '(:line-width 4 :color "#8B0000"))
  (set-face-attribute 'mode-line-inactive nil
                      :background "#5E0400" :foreground "#96652C"
                      :box '(:line-width 4 :color "#5E0400"))
  (set-face-attribute 'mode-line-highlight nil
                      :background "#C17A30" :foreground "#1A0A00" :box nil)

  ;; ウィンドウ境界 = VSCode の sash
  (set-face-attribute 'window-divider nil :foreground "#C17A30")
  (set-face-attribute 'window-divider-first-pixel nil :foreground "#C17A30")
  (set-face-attribute 'window-divider-last-pixel nil :foreground "#C17A30")
  (set-face-attribute 'vertical-border nil :foreground "#C17A30")

  ;; タブバー = VSCode の activityBar
  (set-face-attribute 'tab-bar nil :background "#1A0A00" :foreground "#96652C")
  (set-face-attribute 'tab-bar-tab nil
                      :background "#C17A30" :foreground "#1A0A00" :weight 'bold)
  (set-face-attribute 'tab-bar-tab-inactive nil
                      :background "#1A0A00" :foreground "#96652C")

  ;; エディタタブ = VSCode の editorGroupHeader / tab
  ;; アクティブなタブだけエディタ本体と同じ背景にして「地続き」に見せる。
  (set-face-attribute 'tab-line nil
                      :background "#1A0A00" :foreground "#96652C"
                      :height 0.9 :box nil :inherit 'unspecified)
  (set-face-attribute 'tab-line-tab nil
                      :background "#0D0D0D" :foreground "#E8A24A"
                      :box '(:line-width 3 :color "#0D0D0D") :inherit 'unspecified)
  (set-face-attribute 'tab-line-tab-current nil
                      :background "#0D0D0D" :foreground "#E8A24A" :weight 'bold
                      :box '(:line-width 3 :color "#0D0D0D") :inherit 'unspecified)
  (set-face-attribute 'tab-line-tab-inactive nil
                      :background "#1A0A00" :foreground "#96652C"
                      :box '(:line-width 3 :color "#1A0A00") :inherit 'unspecified)
  (set-face-attribute 'tab-line-highlight nil          ; マウスホバー
                      :background "#C17A30" :foreground "#1A0A00"
                      :box '(:line-width 3 :color "#C17A30"))

  ;; 細部
  (set-face-attribute 'cursor nil :background "#E8A24A")
  (set-face-attribute 'minibuffer-prompt nil :foreground "#E8A24A" :weight 'bold)

  ;; doom-modeline 左端のバー
  (when (facep 'doom-modeline-bar)
    (set-face-attribute 'doom-modeline-bar nil :background "#C17A30"))
  (when (facep 'doom-modeline-bar-inactive)
    (set-face-attribute 'doom-modeline-bar-inactive nil :background "#5E0400"))

  ;; フリンジはテーマ既定だと灰色の帯が浮くので、エディタ背景に馴染ませる
  (set-face-attribute 'fringe nil :inherit 'default :background 'unspecified)

  ;; 変更ファイル数バッジ（VSCode の activityBarBadge = 赤地に白文字）
  (when (facep 'my/git-badge-face)
    (set-face-attribute 'my/git-badge-face nil
                        :background "#B30000" :foreground "#E8A24A"
                        :weight 'bold :box nil))

  ;; diff-hl の変更マーカー
  (when (facep 'diff-hl-insert)
    (set-face-attribute 'diff-hl-insert nil :background "#C17A30" :foreground "#C17A30"))
  (when (facep 'diff-hl-change)
    (set-face-attribute 'diff-hl-change nil :background "#E8A24A" :foreground "#E8A24A"))
  (when (facep 'diff-hl-delete)
    (set-face-attribute 'diff-hl-delete nil :background "#8B0000" :foreground "#8B0000"))

  ;; treemacs = VSCode の activityBar。#1A0A00 の置き場所はここ
  (when (facep 'treemacs-root-face)
    (set-face-attribute 'treemacs-root-face nil
                        :foreground "#E8A24A" :weight 'bold :height 1.0 :underline nil))
  (when (facep 'treemacs-directory-face)
    (set-face-attribute 'treemacs-directory-face nil :foreground "#C17A30"))
  (when (facep 'treemacs-file-face)
    (set-face-attribute 'treemacs-file-face nil :foreground "#96652C")))

;; treemacs のサイドバーだけ背景を変える。
;; treemacs には「ウィンドウ背景」のフェイスが無いので、
;; バッファローカルに default フェイスを差し替える（face-remap）方式を採る。
(add-hook 'treemacs-mode-hook
          (lambda ()
            (face-remap-add-relative 'default :background "#1A0A00")
            (face-remap-add-relative 'fringe  :background "#1A0A00")))

;; ウィンドウ境界線を実際に描画させる
;; NOTE: 右側の幅は「見た目の線の太さ」と「マウスで掴める当たり判定」を兼ねる。
;;       1px だとウィンドウ境界をドラッグして掴むのが実質不可能なので 4px にしてある。
;;       細い線に戻したい場合は 1 に下げる（代わりにマウスでのリサイズは諦める）。
(setq window-divider-default-places t
      window-divider-default-right-width 4
      window-divider-default-bottom-width 1)
(window-divider-mode 1)

;; テーマを切り替えても外枠の配色は維持する
(advice-add 'load-theme :after
            (lambda (&rest _) (my/apply-peacock-chrome)))

;; NOTE: 実際の適用はファイル末尾で行う。
;;   この関数は diff-hl や treemacs のフェイスも触るため、
;;   それらを require する前に呼ぶと (facep ...) のガードに阻まれて空振りする。

;;; ---------------------------------------------------------------
;;; PATH の取り込み
;;; ---------------------------------------------------------------
;; macOS では Dock / Finder から起動したアプリはシェルの PATH を引き継がず、
;; launchd の最小 PATH になる。そのため homebrew 等に入れたコマンド
;; （claude, git, python …）が Emacs から見つからない。
;; ログインシェルに問い合わせて PATH を取り込む。
;;
;; 取り込むのは PATH と MANPATH のみ（exec-path-from-shell-variables の既定）。
;; API キー等の秘匿値は取り込まない。

(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;; ---------------------------------------------------------------
;;; ターミナル（VSCode の統合ターミナル相当）
;;; ---------------------------------------------------------------
;; eat = 純 elisp の端末エミュレータ（NonGNU ELPA、ビルド不要）。
;;
;; NOTE: eshell / M-x shell では claude・vim・top のような全画面 TUI は動かない。
;;       これらは comint ベースの「行指向」インターフェースで、
;;       カーソル移動やANSIエスケープを解釈する PTY を持たないため。
;;       eat はそれを持つので TUI アプリが動く。
;;
;; 表示は Emacs 標準の side window。左は treemacs が使っているので下に出す。
;; side を 'right や 'top に変えれば位置は動かせる。

(require 'eat)

;; 描画のちらつき対策。
;; eat は「チャンクを受け取ったら少し待ち、その間に次が来たら再描画を先送りする」
;; 方式でちらつきを抑えている。既定は min 0.008 / max 0.033 秒（約30fps）で、
;; Claude Code のような全画面を毎回描き直す TUI では中途半端な状態が
;; 何度も描画されて上下に揺れて見える。待ち時間を延ばしてまとめて描く。
;;   小さくする -> 反応は速いがちらつく / 大きくする -> 滑らかだが表示が遅れる
(setq eat-minimum-latency 0.03
      eat-maximum-latency 0.10)

(setq display-buffer-alist
      (append display-buffer-alist
              ;; *eat* / *eat*<2> / *tank-eat*（eat-project）/ *eshell* / *shell*
              '(("\\`\\*\\(?:.*-\\)?eat\\*\\(?:<[0-9]+>\\)?\\'\\|\\`\\*e?shell\\*\\'"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (slot . 0)
                 (window-height . 0.3)          ; フレーム高さの30%
                 (window-parameters
                  ;; C-x 1（他のウィンドウを全部閉じる）でも消えないようにする
                  (no-delete-other-windows . t))))))

(defun my/toggle-terminal ()
  "下部のサイドウィンドウで eat を開閉する。
VSCode の Ctrl+` と同じ挙動にする:
  閉じている  -> 開いてフォーカスを移す
  開いている  -> フォーカスを移す
  フォーカス中 -> 閉じる"
  (interactive)
  (let ((win (get-buffer-window eat-buffer-name)))
    (cond
     ((and win (eq win (selected-window))) (delete-window win))
     (win (select-window win))
     (t (eat)))))

(global-set-key (kbd "C-c s") #'my/toggle-terminal)
;; サイドウィンドウ（treemacs 含む）を一括で開閉する標準コマンド
(global-set-key (kbd "C-c w") #'window-toggle-side-windows)

;;; ---------------------------------------------------------------
;;; ウィンドウ間の移動
;;; ---------------------------------------------------------------
;; windmove / winner はどちらも Emacs 同梱。
;;
;; NOTE: windmove の既定は S-<arrow> だが、それだと **シフト+矢印の範囲選択**が
;;       使えなくなる（S-<arrow> は明示的な割り当てではなく shift-translation で
;;       選択に使われているため、上書きすると選択側が死ぬ）。
;;       完全に空いている C-c <arrow> を使う。

;; NOTE: windmove-default-keybindings は修飾キー（shift/meta/control 等）しか
;;       受け付けず、C-c のようなプレフィックスは渡せない。個別に割り当てる。
(require 'windmove)
(global-set-key (kbd "C-c <left>")  #'windmove-left)
(global-set-key (kbd "C-c <right>") #'windmove-right)
(global-set-key (kbd "C-c <up>")    #'windmove-up)
(global-set-key (kbd "C-c <down>")  #'windmove-down)

;; NOTE: winner-mode は既定で C-c <left> / C-c <right> を奪うので先に止める。
(setq winner-dont-bind-my-keys t)
(winner-mode 1)
(global-set-key (kbd "C-c u") #'winner-undo)   ; ウィンドウ配置を元に戻す
(global-set-key (kbd "C-c U") #'winner-redo)

;;; ---------------------------------------------------------------
;;; Git（magit + diff-hl）
;;; ---------------------------------------------------------------

(require 'magit)
(global-set-key (kbd "C-c g") #'magit-status)

;; treemacs のサイドバーを magit の操作に追随させる
(require 'treemacs-magit)

;; 行左端に変更マーカーを出す（VSCode の gutter 相当）
;; マーカーはフリンジ（テキスト領域の外側の帯）に描かれる。
;; 既定の 8px では細くて見えないので左フリンジを広げる。
(fringe-mode '(16 . 8))               ; 左16px / 右8px

(require 'diff-hl)
(global-diff-hl-mode 1)
(diff-hl-flydiff-mode 1)              ; 保存前の編集中も差分を反映する
(add-hook 'dired-mode-hook #'diff-hl-dired-mode)

;; magit で stage/commit した直後にマーカーを更新する
(add-hook 'magit-pre-refresh-hook  #'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)

;;; --- 変更ファイル数のバッジ（VSCode の activityBarBadge 相当）-------
;; Emacs にアクティビティバーは無いので、モードラインのブランチ名の隣に出す。
;; git status は再描画のたびに走らせると重いので、
;; ファイル保存時と magit 更新時にだけ計算してキャッシュする。

(defvar my/git-change-count (make-hash-table :test 'equal)
  "リポジトリルート -> 変更ファイル数 のキャッシュ。")

(defun my/git-root ()
  "現在のバッファが属する git リポジトリのルートを返す。
NOTE: vc-root-dir は使えない。あれは「そのファイル自身が追跡されていること」を
      前提にしており、新規作成した未追跡ファイルを開くと nil を返す
      （リポジトリ内にいるのにバッジが消える）。
      .git を上に辿る方式なら追跡状態に依存せず、
      *eat* や dired のような非ファイルバッファでも効く。"
  (when-let* ((dir (locate-dominating-file default-directory ".git")))
    (expand-file-name dir)))

(defun my/git-count-changes (root)
  "ROOT の変更ファイル数を数える。--porcelain は1変更につき1行。
NOTE: -uall は必須。付けないと git は未追跡ディレクトリを
      `?? path/dir/' の1行に畳んでしまい、中に10ファイルあっても1と数える
      （VSCode の Source Control バッジはファイル単位なので値がずれる）。"
  (let ((default-directory root))
    (with-temp-buffer
      (if (zerop (call-process "git" nil t nil "status" "--porcelain" "-uall"))
          (count-lines (point-min) (point-max))
        0))))

(defun my/git-change-count-update (&rest _)
  "現在のバッファが属するリポジトリの変更ファイル数を数え直す。"
  (when-let* ((root (my/git-root)))
    (puthash root (my/git-count-changes root) my/git-change-count)))

(defun my/git-change-badge ()
  "モードラインに出すバッジ文字列。変更が無いときは空。"
  (when-let* ((root (my/git-root))
              (n (gethash root my/git-change-count)))
    (when (> n 0)
      (propertize (format " %d " n) 'face 'my/git-badge-face))))

(defface my/git-badge-face
  '((t :inherit mode-line))
  "変更ファイル数バッジのフェイス（色は my/apply-peacock-chrome で指定）。")

;; doom-modeline は global-mode-string を misc-info セグメントに表示する。
;; モードライン全体を再定義するより壊れにくいのでこちらを使う。
(add-to-list 'global-mode-string '(:eval (my/git-change-badge)) t)

;; treemacs のプロジェクト行にも同じ数字を出す。
;; treemacs のアノテーションAPI（lsp-treemacs が診断件数の表示に使っているもの）を利用する。
(defun my/treemacs-update-git-badges (&rest _)
  "登録済み全プロジェクトの行に変更ファイル数のバッジを付ける。
引数を取るのは treemacs-post-refresh-hook が引数付きで呼ぶため。"
  (interactive)
  (when (fboundp 'treemacs-current-workspace)
    (dolist (project (ignore-errors (treemacs-workspace->projects (treemacs-current-workspace))))
      (let* ((root (treemacs-project->path project))
             (n (if (file-directory-p (expand-file-name ".git" root))
                    (my/git-count-changes root)
                  0)))
        (if (> n 0)
            (treemacs-set-annotation-suffix
             root (propertize (format " %d " n) 'face 'my/git-badge-face) "git-count")
          (treemacs-remove-annotation-suffix root "git-count"))
        ;; NOTE: apply-annotations は treemacs バッファが current でないと効かない。
        ;;       after-save-hook 等はファイルバッファから呼ばれるので明示的に切り替える。
        (treemacs-run-in-every-buffer
         (ignore-errors (treemacs-apply-annotations root)))))))

(defun my/git-change-count-update-all (&rest _)
  "モードラインと treemacs のバッジをまとめて更新する。"
  (my/git-change-count-update)
  (my/treemacs-update-git-badges))

(add-hook 'after-save-hook         #'my/git-change-count-update-all)
(add-hook 'find-file-hook          #'my/git-change-count-update)
(add-hook 'magit-post-refresh-hook #'my/git-change-count-update-all)

;; treemacs 側の反映タイミング。
;; NOTE: treemacs-mode-hook は使えない。メジャーモード設定時＝ツリー描画前に走るため、
;;       アノテーションを付ける対象のノードがまだ存在せず空振りする。
(add-hook 'treemacs-post-buffer-init-hook #'my/treemacs-update-git-badges) ; 初回描画後
(add-hook 'treemacs-select-hook           #'my/treemacs-update-git-badges) ; ツリーに移った時
(add-hook 'treemacs-post-refresh-hook     #'my/treemacs-update-git-badges) ; 更新後

;;; ---------------------------------------------------------------
;;; tree-sitter（構文解析ベースのハイライト）
;;; ---------------------------------------------------------------
;; *-ts-mode は Emacs 30 に同梱されているが、言語ごとの「文法」は別途ビルドが要る。
;; 未導入の言語は M-x treesit-install-language-grammar で入れる（cc と git が必要）。
;; ビルド済みの文法は ~/.emacs.d/tree-sitter/ に置かれる。

;; NOTE: バージョンは必ず固定すること。
;;   各文法の master は tree-sitter 0.25 系（ABI 15）に移行済みだが、
;;   Emacs 30.2 が読めるのは ABI 13〜14（M-: (treesit-library-abi-version) で確認できる）。
;;   master のまま入れると "version-mismatch: 15" でビルドは通るのに使えない。
(setq treesit-language-source-alist
      '((rust       "https://github.com/tree-sitter/tree-sitter-rust"       "v0.23.3")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")
        (python     "https://github.com/tree-sitter/tree-sitter-python"     "v0.23.6")
        (json       "https://github.com/tree-sitter/tree-sitter-json"       "v0.24.8")
        (yaml       "https://github.com/ikatyang/tree-sitter-yaml"          "v0.5.0")
        (toml       "https://github.com/tree-sitter/tree-sitter-toml"       "v0.5.1")
        (bash       "https://github.com/tree-sitter/tree-sitter-bash"       "v0.23.3")))

;; 既存のメジャーモードを ts 版に読み替える
(setq major-mode-remap-alist
      '((python-mode    . python-ts-mode)
        (js-json-mode   . json-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (sh-mode        . bash-ts-mode)))

;; 旧モードが同梱されていない拡張子は自分で紐づける
(dolist (entry '(("\\.rs\\'"    . rust-ts-mode)
                 ("\\.ts\\'"    . typescript-ts-mode)
                 ("\\.tsx\\'"   . tsx-ts-mode)
                 ("\\.ya?ml\\'" . yaml-ts-mode)))
  (add-to-list 'auto-mode-alist entry))

;;; ---------------------------------------------------------------
;;; Markdown（プレビュー状態のまま編集する）
;;; ---------------------------------------------------------------
;; VSCode は「ソース」と「プレビュー」を別ペインに並べる方式で、
;; プレビュー側は生成された HTML なので編集できない。
;; markdown-mode の markdown-hide-markup は方式が違う。
;; 別バッファを作らず、ファイルを開いているバッファ自体に
;; invisible / display のテキストプロパティを被せて記法を隠す。
;; 見えているものが実ファイルそのものなので、そのまま編集できる。
;; Obsidian の Live Preview と同じモデル。
;;
;; NOTE: 唯一の差は「カーソルを乗せても記法が戻らない」こと。
;;       org には org-appear があるが markdown 版は無い。
;;       ** の境界が見えないまま消してしまう事故が起きたら
;;       C-c C-x C-m (markdown-toggle-markup-hiding) で一時的に戻す。

(require 'markdown-mode)

;; .md は gfm-mode（GitHub Flavored Markdown）で開く。
;; NOTE: これは見た目の好みではなく必須。素の markdown-mode は語中の _ も
;;       イタリックの記法と解釈するため、markdown-hide-markup と併用すると
;;       [[20260813_orgmode_usage_patterns]] が
;;       「20260813orgmodeusagepatterns」と表示されてしまう（_ が隠される）。
;;       GFM は語中の _ を強調と見なさない仕様で、gfm-mode はそれを実装している
;;       （markdown--gfm-markup-underscore-p）。tank のファイル名は全部 _ 区切り。
;;       ついでに gfm-mode は wikilink をサブディレクトリまで探しに行く
;;       （markdown-wiki-link-search-subdirectories t）ので、
;;       memo が月別フォルダへ移動しても [[...]] が追える。
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))

;; NOTE: markdown-hide-markup は make-variable-buffer-local されている。
;;       素の setq だと *scratch* だけに効いて、markdown ファイルを開いても
;;       グローバルの既定値（nil）が読まれるため何も隠れない。setq-default が要る。
(setq-default markdown-hide-markup t)           ; ** _ [] () を隠しリストマーカーを記号化

;; NOTE: markdown-header-scaling は :set で markdown-update-header-faces を呼んで
;;       フェイスの :height を書き換える defcustom。setq では :set が走らず
;;       見出しの大きさが変わらないので customize-set-variable を使う。
(customize-set-variable 'markdown-header-scaling t)  ; 見出しを 2.0 1.7 1.4 1.1 1.0 1.0 で拡大

(setq markdown-fontify-code-blocks-natively t   ; コードブロックを言語のフェイスで着色
      markdown-enable-wiki-links t              ; [[wikilink]]（tank / Obsidian の記法）
      markdown-wiki-link-fontify-missing t)     ; リンク先が無い [[...]] を色で警告

;; NOTE: variable-pitch-mode（プロポーショナルフォント）は入れない。
;;       tank のメモは表が多く、表の桁揃えは文字数ベースなので
;;       等幅でないと崩れる。HackGen Console NF は全角＝半角2つ分の
;;       幅で描画されるため、等幅のままなら日本語混じりの表も揃う。

;; 日本語は1行が長くなるのでウィンドウ幅で折り返す（ファイルには改行を入れない）
(add-hook 'markdown-mode-hook #'visual-line-mode)

;; 主なキー（markdown-mode 標準）
;;   C-c C-x C-m  記法の表示/非表示トグル
;;   C-c C-x C-i  画像のインライン表示トグル
;;   TAB / S-TAB  見出しの折りたたみ / 全体のアウトライン切り替え
;;   C-c C-d      文脈依存。チェックボックス切替・参照/脚注ジャンプ・表の整形
;;   C-c C-o      リンク・wikilink を開く
;;   C-c C-c c    未定義の参照リンクを検出

;;; ---------------------------------------------------------------
;;; macOS のタイトルバー
;;; ---------------------------------------------------------------
;; macOS のタイトルバーは任意色にできないため、透過させてフレームと一体化させる

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;;; ---------------------------------------------------------------
;;; 配色の適用（すべてのパッケージ読み込み後）
;;; ---------------------------------------------------------------

(my/apply-peacock-chrome)

;;; init.el ends here
