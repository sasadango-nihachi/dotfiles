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
    treemacs-magit)
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

;; Emacs 同梱の misterioso = 青緑系の暗い背景
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

(setq treemacs-width 45
      treemacs-position 'left
      treemacs-indentation 2
      treemacs-show-hidden-files nil
      treemacs-follow-after-init t)       ; 開いているファイルの位置にツリーを追随させる

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
(setq window-divider-default-places t
      window-divider-default-right-width 1
      window-divider-default-bottom-width 1)
(window-divider-mode 1)

;; テーマを切り替えても外枠の配色は維持する
(advice-add 'load-theme :after
            (lambda (&rest _) (my/apply-peacock-chrome)))

;; NOTE: 実際の適用はファイル末尾で行う。
;;   この関数は diff-hl や treemacs のフェイスも触るため、
;;   それらを require する前に呼ぶと (facep ...) のガードに阻まれて空振りする。

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

(defun my/git-change-count-update (&rest _)
  "現在のバッファが属するリポジトリの変更ファイル数を数え直す。"
  (when-let* ((file (buffer-file-name))
              (root (ignore-errors (vc-root-dir))))
    (let ((default-directory root))
      (puthash (expand-file-name root)
               (with-temp-buffer
                 ;; --porcelain は1変更につき1行。未追跡ファイルも含む
                 (if (zerop (call-process "git" nil t nil "status" "--porcelain"))
                     (count-lines (point-min) (point-max))
                   0))
               my/git-change-count))))

(defun my/git-change-badge ()
  "モードラインに出すバッジ文字列。変更が無いときは空。"
  (when-let* ((root (ignore-errors (vc-root-dir)))
              (n (gethash (expand-file-name root) my/git-change-count)))
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
             (n (with-temp-buffer
                  (let ((default-directory root))
                    (if (zerop (call-process "git" nil t nil "status" "--porcelain"))
                        (count-lines (point-min) (point-max))
                      0)))))
        (if (> n 0)
            (treemacs-set-annotation-suffix
             root (propertize (format " %d " n) 'face 'my/git-badge-face) "git-count")
          (treemacs-remove-annotation-suffix root "git-count"))
        (ignore-errors (treemacs-apply-annotations root))))))

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
