;;-------------------------------------------------------------------------
;; ws.el: emacs の キーバインドをWordStar like に設定する
;;
;;    Copyright (C) 2021 ISHIKAWA Toshikazu.
;;					石川寿一
;;					tosh@i.nifty.jp
;; 
;;-------------------------------------------------------------------------

;; (defvar WordStar t) ;; byte-compile時、「lacks a prefix」とWarning
;;
;;--------  keyboard-translate-table の変更 --
;;
;; HACK: 古いemacs用のコードが残っているので削除が必要
(if (boundp `xemacs-betaname)
    (progn (keyboard-translate ?\^b ?\^s)	; ^B ^S
	   (keyboard-translate ?\^c ?\^e)	; ^C ^E
	   (keyboard-translate ?\^d ?\^f)	; ^D ^F
	   (keyboard-translate ?\^e ?\^p)	; ^E ^P
	   (keyboard-translate ?\^f 29)	; ^F ^]
	   (keyboard-translate ?\^g ?\^d)	; ^G ^D
	   (keyboard-translate ?\^h 127)	; ^H DEL
	   (keyboard-translate ?\^j ?\^h)	; LFD ^H
	   (keyboard-translate ?\^k ?\^y)	; ^K ^Y
	   (keyboard-translate ?\^n ?\^o)	; ^N ^O
	   (keyboard-translate 27 ?\^g)		; ESC ^G
	   (keyboard-translate ?\^o ?\^c)	; ^O ^C
	   (keyboard-translate ?\^p ?\^x)	; ^P ^X
	   (keyboard-translate ?\^q 28)		; ^Q ^\
	   (keyboard-translate ?\^s ?\^b)	; ^S ^B
	   (keyboard-translate ?\^x ?\^n)	; ^X ^N
	   (keyboard-translate ?\^y ?\^k)	; ^Y ^K
	   (keyboard-translate ?\^n ?\^o)	; ^N ^O
	   (keyboard-translate 28 ?\^q)		; ^\ ^q
	   (keyboard-translate 29 27)		; ^] ESC
	   (keyboard-translate 127 ?\^j))	; DEL LFD
  (let ((the-table (make-string 128 0)))
       (let ((i 0))
	 (while (< i 128)
	   (aset the-table i i)
	   (setq i (1+ i))))
       (aset the-table ?\^b ?\^s)		; ^B ^S
       (aset the-table ?\^c ?\^e)		; ^C ^E
       (aset the-table ?\^d ?\^f)		; ^D ^F
       (aset the-table ?\^e ?\^p)		; ^E ^P
       (aset the-table ?\^f 29)			; ^F ^]
       (aset the-table ?\^g ?\^d)		; ^G ^D
       (aset the-table ?\^h 127)		; ^H DEL
       (aset the-table ?\^j ?\^h)		; LFD ^H
       (aset the-table ?\^k ?\^y)		; ^K ^Y
       (aset the-table ?\^n ?\^o)		; ^N ^O
       (aset the-table 27 ?\^g)			; ESC ^G
       (aset the-table ?\^o ?\^c)		; ^O ^C
       (aset the-table ?\^p ?\^x)		; ^P ^X
       (aset the-table ?\^q 28)			; ^Q ^\
       (aset the-table ?\^s ?\^b)		; ^S ^B
       (aset the-table ?\^x ?\^n)		; ^X ^N
       (aset the-table ?\^y ?\^k)		; ^Y ^K
       (aset the-table ?\^n ?\^o)		; ^N ^O
       (aset the-table 28 ?\^q)			; ^\ ^q
       (aset the-table 29 27)			; ^] ESC
       (aset the-table 127 ?\^j)		; DEL LFD
       (setq keyboard-translate-table the-table))
)
;;
;;-------- 関数定義 --------------------------
;
;;
;; quail-mode
;; quail を無効化する。
;;
;; (or (fboundp 'quail-mode)
;;    (fset 'quail-mode-org (symbol-function 'quail-mode)))
;; (fset 'quail-mode (symbol-function 'forward-word)))

;; quoted-insert
;; quote 関数のオリジナルを取っておく
(or (fboundp 'quoted-insert-org)
    (fset 'quoted-insert-org (symbol-function 'quoted-insert)))


(defun quoted-insert (arg)
  "次に入力された文字を挿入する。コントロールコードを入力する時に役に立つ。
もし、3 桁の 8 進数を入力すると、その文字コードの文字を挿入する。
この関数は WordStar エミュレーションのために変更してある。WordStar エミュレー
ションでは、keyboard-translate-table を書き直しているので、そのままでは押し
たキーと異なる文字が挿入されてしまうが、その場合でも正しく動作するように変更
してある。"
  (interactive "*p")
  (let ((char (read-quoted-char)))
    (if (< char 128)
	(let ((i 0))
	  (while (< i 128)
	    (if (= (aref keyboard-translate-table i) char)
		(progn (setq char i)
		       (setq i 255))
		(setq i (1+ i))))))
    (while (> arg 0)
      (insert char)
      (setq arg (1- arg)))))
;;
;; ws-beginning-of-line
;;;
(defun ws-beginning-of-line ()
  " カーソルを画面の左端に位置づける.
  beginning-of-line と違って, 画面の幅を超えるような長い行が, (見かけ上)複数
の行として表示されている場合には, その見かけ上の行を一行として扱う. 例えば,
日本語のテキスト等で, 一つのパラグラフの中に, 全く改行を含めないような書きか
たをしている場合に, beginning-of-line は, パラグラフの先頭に移動するのに対し,
ws-beginning-of-line の場合にはカーソルが水平に移動する."
  (interactive)
  (cond
   ( (not (zerop (vertical-motion 1)))
     (vertical-motion -1) )
   ( (not (zerop (vertical-motion -1)))
     (vertical-motion 1) )
   ( t (beginning-of-line) )))

;;;
;; ws-end-of-line
;;;
(defun ws-end-of-line ()
  "  カーソルを画面の右端に位置づける.
  end-of-line と異なり, 画面の幅を超えるような長い行が, (見かけ上)複数の行と
して表示されている場合には, その見かけ上の行を一行として扱う. 例えば, 日本語
のテキスト等で, 一つのパラグラフの中に, 全く改行を含めないような書きかたをし
ている場合に, end-of-line では, パラグラフの先頭に移動するのに対し,
ws-end-of-line の場合にはカーソルが水平に移動する."
  (interactive)
  (if (not (zerop (vertical-motion 1)))
      (backward-char)
    (end-of-line)))

;;--------------------------------------------
;; hunt-forward
;;
(defun hunt-forward ()
  "直前に検索した内容を前方に再検索"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (search-forward isearch-string)
    (search-forward search-last-string)))
;;
;; hunt-backward
;;
(defun hunt-backward ()
  "直前に検索した内容を後方に再検索"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (search-backward isearch-string)
    (search-backward search-last-string)))
;;
;; hunt-forward-regexp
;;
(defun hunt-forward-regexp ()
  "直前に検索した正規表現を前方に再検索"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (re-search-forward isearch-string)
    (re-search-forward search-last-regexp)))
;;
;; hunt-backward-regexp
;;
(defun hunt-backward-regexp ()
  "直前に検索した正規表現を後方に再検索"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (re-search-backward isearch-string)
    (re-search-backward search-last-regexp)))
;;
;; kill-to-beginning-of-line
;;
(defun kill-to-beginning-of-line ()
  "行頭まで削除"
  (interactive)
  (kill-line 0))
;;
;; kill-one-line
;;
(defun kill-one-line ()
  "一行削除"
  (interactive)
  (beginning-of-line 1)
  (kill-line 1))
;;
;; scroll-down-1-line
;;
(defun scroll-down-1-line ()
  "一行スクロールダウン"
  (interactive)
  (scroll-down 1))
;;
;; scroll-up-1-line
;;
(defun scroll-up-1-line ()
  "一行スクロールアップ"
  (interactive)
  (scroll-up 1))
;;
;; kill-buffer-without-save
;;
(defun kill-buffer-without-save ()
  "現在のバッファをセーブしないでバッファを削除する。"
  (interactive)
;;(delete-window)
  (kill-buffer (buffer-name)))
;;
;; save-buffer-kill-buffer
;;
(defun save-buffer-kill-buffer ()
  "現在のバッファをセーブし、バッファを削除する。"
  (interactive)
  (save-buffer)
;;(delete-window)
  (kill-buffer (buffer-name)))
;;
;; switch-to-next-buffer
;;
(defun switch-to-next-buffer ()
  "現在のウィンドウに別のバッファを表示する"
  (interactive)
  (switch-to-buffer (buffer-name (other-buffer))))

;;
;; previous-error ( based on next-error(compile.el) )
;;
;;(defun previous-error (&optional argp)
;;
;; previous-window-line
;;
(defun previous-window-line (n)
"  通常 emacs では、改行の無い複数行の文章中では previous virtual line に
行かず、previous file line へカーソルが移動してしまうが、これを previous
virtual line に行くように変更するための lisp 関数"
  (interactive "p")
  (let ((cur-col
	 (- (current-column)
	    (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion (- n))
    (move-to-column (+ (current-column) cur-col))))
;;
;; next-window-line
;;
(defun next-window-line (n)
"  通常 emacs では、改行の無い複数行の文章中では next virtual line に行
かず、next file line へカーソルが移動してしまうが、これを next virtual
line に行くように変更するための lisp 関数"
  (interactive "p")
  (let ((cur-col
	 (- (current-column)
	    (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion n)
    (move-to-column (+ (current-column) cur-col))))
;;
;; ws-next-line
;;
;; 未完成なので使っていない。今は C のコードにパッチを当てている。
;;
;;(defun ws-next-line (arg)
;;  "  keyboard-translate-table を書き変えたので、そのままではマウスの入力
;;が効かないので、マウスのときは別の処理を行なう"
;;  (interactive "p")
;;  (if (input-pending-p) (ws-next-line arg)
;;    ("マウスキーバインド"))
;;  )
;;-------- キーマップ定義 --------------------------
;;
;;; ^B キーマップ
;;
(defvar ctl-b-map (make-sparse-keymap))
;;(define-key ctl-b-map "\C-a" ')			; ^B^A
(define-key ctl-b-map "\C-s" 'fill-region)		; ^B^B
;;(define-key ctl-b-map "\C-e" ')			; ^B^C
;;(define-key ctl-b-map "\C-f" ')			; ^B^D
;;(define-key ctl-b-map "\C-p" ')			; ^B^E
;;(define-key ctl-b-map "\C-]" ')			; ^B^F
;;(define-key ctl-b-map "\C-f" ')			; ^B^G
;;(define-key ctl-b-map "\177" ')			; ^B^H
;;(define-key ctl-b-map "\t"   ')			; ^B^I
;;(define-key ctl-b-map "\C-j" ')			; ^B^J
;;(define-key ctl-b-map "\C-y" )			; ^B^K
;;(define-key ctl-b-map "\C-l" ')			; ^B^L
;;(define-key ctl-b-map "\C-m" ')			; ^B^M
;;(define-key ctl-b-map "\C-o" ')			; ^B^N
;;(define-key ctl-b-map "\C-c" ')			; ^B^O
;;(define-key ctl-b-map "\C-x" ')			; ^B^P
;;(define-key ctl-b-map "\034" )			; ^B^Q
;;(define-key ctl-b-map "\C-r" ')			; ^B^R
;;(define-key ctl-b-map "\C-b" ')			; ^B^S
;;(define-key ctl-b-map "\C-t" ')			; ^B^T
;;(define-key ctl-b-map "\C-u" )			; ^B^U
;;(define-key ctl-b-map "\C-v" ')			; ^B^V
;;(define-key ctl-b-map "\C-w" ')			; ^B^W
;;(define-key ctl-b-map "\C-n" ')			; ^B^X
;;(define-key ctl-b-map "\C-k" ')			; ^B^Y
;;(define-key ctl-b-map "\C-z" ')			; ^B^Z
;;(define-key ctl-b-map "\C-j" ')			; ^B^\
;;(define-key ctl-b-map "\C-g" ')			; ^B ESC
;;(define-key ctl-b-map "\027" ')			; ^B^]
;;(define-key ctl-b-map "\036" ')			; ^B^^
;;
;;; ^K キーマップ
;;;
;;(defvar rm-map (make-sparse-keymap))
(defvar ctl-k-map (make-sparse-keymap))
(define-key ctl-k-map "f"    'crear-rectangle)			; ^Kf
(define-key ctl-k-map "n"    'switch-to-next-buffer)		; ^Kn
(define-key ctl-k-map "o"    'open-rectangle)			; ^Ko
(define-key ctl-k-map "p"    'lpr-region)			; ^Kp
;;(define-key ctl-k-map "r"    rm-map)				; ^Kr
(define-key ctl-k-map "y"    'delete-rectangle)		; ^Ky
(define-key ctl-k-map "x"    'find-alternate-file)		; ^Kx
(define-key ctl-k-map "="    'count-lines-resion)		; ^K=
(define-key ctl-k-map "("    'start-kbd-macro)			; ^K(
(define-key ctl-k-map ")"    'end-kbd-macro)			; ^K)
(define-key ctl-k-map "\C-a" 'save-some-buffers)		; ^K^A
(define-key ctl-k-map "\C-s" 'set-mark-command)		; ^K^B
(define-key ctl-k-map "\C-e" 'yank)				; ^K^C
(define-key ctl-k-map "\C-f" 'save-buffers-kill-emacs)		; ^K^D
(define-key ctl-k-map "\C-p" 'set-visited-file-name)		; ^K^E
(define-key ctl-k-map "\C-]" 'shell)				; ^K^F
;;(define-key ctl-k-map "\C-f" ')				; ^K^G
;;(define-key ctl-k-map "\177" ')				; ^K^H
(define-key ctl-k-map "\C-i" 'yank-rectangle)			; ^K^I
(define-key ctl-k-map "\C-h" 'auto-fill-mode)			; ^K^J
(define-key ctl-k-map "\C-y" 'copy-region-as-kill)		; ^K^K
(define-key ctl-k-map "\C-l" 'outline-minor-mode)		; ^K^L
(define-key ctl-k-map "\C-m" 'indent-comment-line)		; ^K^M
(define-key ctl-k-map "\C-o" 'kill-rectangle)			; ^K^N
(define-key ctl-k-map "\C-c" 'find-file-other-window)		; ^K^O
;;(define-key ctl-k-map "\C-x" 'ws-print-buffer)		; ^K^P
(define-key ctl-k-map "\034" 'kill-buffer-without-save)		; ^K^Q
;;(define-key ctl-k-map "\C-r" ')				; ^K^R
(define-key ctl-k-map "\C-b" 'save-buffer)			; ^K^S
;;(define-key ctl-b-map "\C-t" ')				; ^K^T
;;(define-key ctl-b-map "\C-u" )				; ^K^U
;;(define-key ctl-b-map "\C-v" ')				; ^K^V
(define-key ctl-k-map "\C-w" 'save-buffer)			; ^K^W
(define-key ctl-k-map "\C-n" 'save-buffer-kill-buffer)		; ^K^X
(define-key ctl-k-map "\C-k" 'kill-region)			; ^K^Y
;;(define-key ctl-k-map "\C-z" ')				; ^K^Z
;;(define-key ctl-k-map "\C-j" ')				; ^K^\
;;(define-key ctl-k-map "\C-g" ')				; ^K ESC
;;(define-key ctl-k-map "\027" ')				; ^K^]
;;(define-key ctl-k-map "\036" ')				; ^K^^
;;;
;;; ^Q キーマップ
;;;
(defvar ctl-q-map (make-sparse-keymap))
(define-key ctl-q-map "a"    'query-replace-regexp)		; ^Qa
(define-key ctl-q-map "d"    'end-of-line)			; ^Qs
(define-key ctl-q-map "f"    'isearch-backward-regexp)		; ^Qf
(define-key ctl-q-map "i"    'quoted-insert)			; ^Qi
(define-key ctl-q-map "l"    'hunt-forward)			; ^Ql
(define-key ctl-q-map "q"    'what-cursor-position)		; ^Qq
(define-key ctl-q-map "s"    'beginning-of-line)		; ^Qd
(define-key ctl-q-map "="    'what-cursor-position)		; ^Q=
(define-key ctl-q-map "\\"   'quoted-insert)			; ^Q\
(define-key ctl-q-map "\C-a" 'replace-regexp)			; ^Q^A
(define-key ctl-q-map "\C-s" 'indent-region)			; ^Q^B
(define-key ctl-q-map "\C-e" 'end-of-buffer)			; ^Q^C
(define-key ctl-q-map "\C-f" 'ws-end-of-line)			; ^Q^D
;;(define-key ctl-q-map "\C-p" ')				; ^Q^E
(define-key ctl-q-map "\C-]" 'isearch-forward-regexp)		; ^Q^F
;;(define-key ctl-q-map "\C-f" ')				; ^Q^G
(define-key ctl-q-map "\177" 'kill-to-beginning-of-line)	; ^Q^H
;;(define-key ctl-q-map "\t"   ')				; ^Q^I
(define-key ctl-q-map "\C-h" 'goto-line)			; ^Q^J
;;(define-key ctl-b-map "\C-y" )				; ^Q^K
(define-key ctl-q-map "\C-l" 'hunt-backward-regexp)		; ^Q^L
(define-key ctl-q-map "\C-n" esc-map)				; ^Q^M
;;(define-key ctl-q-map "\C-o" ')				; ^Q^N
;;(define-key ctl-q-map "\C-c" ')				; ^Q^O
;;(define-key ctl-q-map "\C-x" ')				; ^Q^P
(define-key ctl-q-map "\034" 'what-line)			; ^Q^Q
(define-key ctl-q-map "\C-r" 'beginning-of-buffer)		; ^Q^R
(define-key ctl-q-map "\C-b" 'ws-beginning-of-line)		; ^Q^S
(define-key ctl-q-map "\t"   'tab-to-tab-stop)			; ^Q^T
;;(define-key ctl-q-map "\C-u" )				; ^Q^U
;;(define-key ctl-q-map "\C-v" ')				; ^Q^V
;;(define-key ctl-q-map "\C-w" ')				; ^Q^W
(define-key ctl-q-map "\C-n" 'execute-extended-command)	; ^Q^X
(define-key ctl-q-map "\C-k" 'kill-line)			; ^Q^Y
;;(define-key ctl-q-map "\C-z" ')				; ^Q^Z
(define-key ctl-q-map "\C-j" 'quoted-insert-org)		; ^Q^\
;;(define-key ctl-b-map "\C-g" ')				; ^Q ESC
;;(define-key ctl-b-map "\C-q" ')				; ^Q^\
;;(define-key ctl-b-map "\027" ')				; ^Q^]
;;(define-key ctl-b-map "\036" ')				; ^Q^^

;;;
;;; ^U キーマップの定義
;;;
(defvar ctl-u-map (make-sparse-keymap))
;; (define-key ctl-u-map "a"    'boss-goes-away)		; ^Ua
;; (define-key ctl-u-map "b"    'boss-has-come)		; ^Ub
(define-key ctl-u-map "o"    'outline-minor-mode)		; ^Uo
(define-key ctl-u-map "\C-a" 'universal-argument)		; ^U^A
(define-key ctl-u-map "\C-s" 'buffer-menu)			; ^U^B
;;;(define-key ctl-u-map "\C-p" 'previous-error)		; ^U^E
(define-key ctl-u-map "\C-u" 'undo)				; ^U^U
(define-key ctl-u-map "\C-n" 'next-error)			; ^U^X

;;;
;;; ^X キーマップの定義
(define-key ctl-x-map "c"    'eval-print-last-sexp)		; ^Pc
;;; ついうっかり押してしまうことが多いので disable する
(define-key ctl-x-map "\C-c" nil)				; ^P^O

;;;
;;; グローバルキーマップの定義
;;;
(define-key global-map "\C-a" 'backward-word)			; ^A
(define-key global-map "\C-s" ctl-b-map)			; ^B
(define-key global-map "\C-e" 'scroll-up)			; ^C
;;;								; ^D
(define-key global-map "\C-p" 'previous-window-line)		; ^E
(define-key global-map "\C-]" 'forward-word)			; ^F
;;;								; ^G
;;;								; ^H
(define-key global-map "\t"   'indent-for-tab-command)		; ^I
;;;								; ^J
(define-key global-map "\C-y" ctl-k-map)			; ^K
(define-key global-map "\C-l" 'hunt-forward-regexp)		; ^L
(define-key global-map "\C-m" 'newline-and-indent)		; ^M
(define-key global-map "\C-o" 'newline)			; ^N
;;;								; ^O
;;;								; ^P
(define-key global-map "\034" ctl-q-map)			; ^Q
(define-key global-map "\C-r" 'scroll-down)			; ^R
;;;								; ^S
(define-key global-map "\C-t" 'kill-word)			; ^T
(define-key global-map "\C-u" ctl-u-map)			; ^U
(define-key global-map "\C-v" 'overwrite-mode)			; ^V
(define-key global-map "\C-w" 'scroll-down-1-line)		; ^W
(define-key global-map "\C-n" 'next-window-line)		; ^X
(define-key global-map "\C-k" 'kill-one-line)			; ^Y
(define-key global-map "\C-z" 'scroll-up-1-line)		; ^Z
;;(define-key global-map "\C-q" 'quoted-insert)		; ^\
(define-key global-map "\036" 'call-last-kbd-macro)		; ^^
(define-key global-map "\037" 'delete-char)			; DEL

(define-key global-map "\000" 'call-last-kbd-macro)

;; isearch-mode
(define-key isearch-mode-map "\C-p" 'isearch-repeat-backward)	; ^E
(define-key isearch-mode-map "\C-l" 'isearch-repeat-forward)	; ^L
(define-key isearch-mode-map "\C-n" 'isearch-repeat-forward)	; ^X
(define-key isearch-mode-map "\M-e" 'isearch-ring-retreat)	; M-e
(define-key isearch-mode-map "\M-k" 'isearch-yank-kill)	; M-k
(define-key isearch-mode-map "\M-x" 'isearch-ring-advance)	; M-x
(define-key isearch-mode-map "\M-\t" 'isearch-complete)	; M-^I


(provide 'ws)
;;
;; For Gnu Emacs.
;; Local Variables:
;; outline-regexp: "^\\([*\^l\\]+\\)\\|\\(;;\\*\\*+\\)"
;; eval: (outline-minor-mode t)
;; eval: (hide-body)
;; End: ***
;;
