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
    nerd-icons-completion)
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
    (set-face-attribute 'doom-modeline-bar-inactive nil :background "#5E0400")))

;; ウィンドウ境界線を実際に描画させる
(setq window-divider-default-places t
      window-divider-default-right-width 1
      window-divider-default-bottom-width 1)
(window-divider-mode 1)

(my/apply-peacock-chrome)

;; テーマを切り替えても外枠の配色は維持する
(advice-add 'load-theme :after
            (lambda (&rest _) (my/apply-peacock-chrome)))

;;; ---------------------------------------------------------------
;;; macOS のタイトルバー
;;; ---------------------------------------------------------------
;; macOS のタイトルバーは任意色にできないため、透過させてフレームと一体化させる

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;;; init.el ends here
