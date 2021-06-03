;;-------------------------------------------------------------------------
;; ws.el: emacs �� �����Х���ɤ�WordStar like �����ꤹ��
;;
;;    Copyright (C) 2021 ISHIKAWA Toshikazu.
;;					�������
;;					tosh@i.nifty.jp
;; 
;;-------------------------------------------------------------------------

;; (defvar WordStar t) ;; byte-compile������lacks a prefix�פ�Warning
;;
;;--------  keyboard-translate-table ���ѹ� --
;;
;; HACK: �Ť�emacs�ѤΥ����ɤ��ĤäƤ���ΤǺ����ɬ��
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
;;-------- �ؿ���� --------------------------
;
;;
;; quail-mode
;; quail ��̵�������롣
;;
;; (or (fboundp 'quail-mode)
;;    (fset 'quail-mode-org (symbol-function 'quail-mode)))
;; (fset 'quail-mode (symbol-function 'forward-word)))

;; quoted-insert
;; quote �ؿ��Υ��ꥸ�ʥ���äƤ���
(or (fboundp 'quoted-insert-org)
    (fset 'quoted-insert-org (symbol-function 'quoted-insert)))


(defun quoted-insert (arg)
  "�������Ϥ��줿ʸ�����������롣����ȥ��륳���ɤ����Ϥ���������Ω�ġ�
�⤷��3 ��� 8 �ʿ������Ϥ���ȡ�����ʸ�������ɤ�ʸ�����������롣
���δؿ��� WordStar ���ߥ�졼�����Τ�����ѹ����Ƥ��롣WordStar ���ߥ�졼
�����Ǥϡ�keyboard-translate-table ���ľ���Ƥ���Τǡ����ΤޤޤǤϲ���
�������Ȱۤʤ�ʸ������������Ƥ��ޤ��������ξ��Ǥ�������ư���褦���ѹ�
���Ƥ��롣"
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
  " �����������̤κ�ü�˰��֤Ť���.
  beginning-of-line �Ȱ�ä�, ���̤�����Ķ����褦��Ĺ���Ԥ�, (��������)ʣ��
�ιԤȤ���ɽ������Ƥ�����ˤ�, ���θ�������ιԤ��ԤȤ��ư���. �㤨��,
���ܸ�Υƥ���������, ��ĤΥѥ饰��դ����, �������Ԥ�ޤ�ʤ��褦�ʽ񤭤�
���򤷤Ƥ������, beginning-of-line ��, �ѥ饰��դ���Ƭ�˰�ư����Τ��Ф�,
ws-beginning-of-line �ξ��ˤϥ������뤬��ʿ�˰�ư����."
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
  "  �����������̤α�ü�˰��֤Ť���.
  end-of-line �Ȱۤʤ�, ���̤�����Ķ����褦��Ĺ���Ԥ�, (��������)ʣ���ιԤ�
����ɽ������Ƥ�����ˤ�, ���θ�������ιԤ��ԤȤ��ư���. �㤨��, ���ܸ�
�Υƥ���������, ��ĤΥѥ饰��դ����, �������Ԥ�ޤ�ʤ��褦�ʽ񤭤�����
�Ƥ������, end-of-line �Ǥ�, �ѥ饰��դ���Ƭ�˰�ư����Τ��Ф�,
ws-end-of-line �ξ��ˤϥ������뤬��ʿ�˰�ư����."
  (interactive)
  (if (not (zerop (vertical-motion 1)))
      (backward-char)
    (end-of-line)))

;;--------------------------------------------
;; hunt-forward
;;
(defun hunt-forward ()
  "ľ���˸����������Ƥ������˺Ƹ���"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (search-forward isearch-string)
    (search-forward search-last-string)))
;;
;; hunt-backward
;;
(defun hunt-backward ()
  "ľ���˸����������Ƥ�����˺Ƹ���"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (search-backward isearch-string)
    (search-backward search-last-string)))
;;
;; hunt-forward-regexp
;;
(defun hunt-forward-regexp ()
  "ľ���˸�����������ɽ���������˺Ƹ���"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (re-search-forward isearch-string)
    (re-search-forward search-last-regexp)))
;;
;; hunt-backward-regexp
;;
(defun hunt-backward-regexp ()
  "ľ���˸�����������ɽ��������˺Ƹ���"
  (interactive)
  (if (<= 19 (string-to-number (substring emacs-version 0 2)))
      (re-search-backward isearch-string)
    (re-search-backward search-last-regexp)))
;;
;; kill-to-beginning-of-line
;;
(defun kill-to-beginning-of-line ()
  "��Ƭ�ޤǺ��"
  (interactive)
  (kill-line 0))
;;
;; kill-one-line
;;
(defun kill-one-line ()
  "��Ժ��"
  (interactive)
  (beginning-of-line 1)
  (kill-line 1))
;;
;; scroll-down-1-line
;;
(defun scroll-down-1-line ()
  "��ԥ������������"
  (interactive)
  (scroll-down 1))
;;
;; scroll-up-1-line
;;
(defun scroll-up-1-line ()
  "��ԥ������륢�å�"
  (interactive)
  (scroll-up 1))
;;
;; kill-buffer-without-save
;;
(defun kill-buffer-without-save ()
  "���ߤΥХåե��򥻡��֤��ʤ��ǥХåե��������롣"
  (interactive)
;;(delete-window)
  (kill-buffer (buffer-name)))
;;
;; save-buffer-kill-buffer
;;
(defun save-buffer-kill-buffer ()
  "���ߤΥХåե��򥻡��֤����Хåե��������롣"
  (interactive)
  (save-buffer)
;;(delete-window)
  (kill-buffer (buffer-name)))
;;
;; switch-to-next-buffer
;;
(defun switch-to-next-buffer ()
  "���ߤΥ�����ɥ����̤ΥХåե���ɽ������"
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
"  �̾� emacs �Ǥϡ����Ԥ�̵��ʣ���Ԥ�ʸ����Ǥ� previous virtual line ��
�Ԥ�����previous file line �إ������뤬��ư���Ƥ��ޤ���������� previous
virtual line �˹Ԥ��褦���ѹ����뤿��� lisp �ؿ�"
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
"  �̾� emacs �Ǥϡ����Ԥ�̵��ʣ���Ԥ�ʸ����Ǥ� next virtual line �˹�
������next file line �إ������뤬��ư���Ƥ��ޤ���������� next virtual
line �˹Ԥ��褦���ѹ����뤿��� lisp �ؿ�"
  (interactive "p")
  (let ((cur-col
	 (- (current-column)
	    (save-excursion (vertical-motion 0) (current-column)))))
    (vertical-motion n)
    (move-to-column (+ (current-column) cur-col))))
;;
;; ws-next-line
;;
;; ̤�����ʤΤǻȤäƤ��ʤ������� C �Υ����ɤ˥ѥå������ƤƤ��롣
;;
;;(defun ws-next-line (arg)
;;  "  keyboard-translate-table ����Ѥ����Τǡ����ΤޤޤǤϥޥ���������
;;�������ʤ��Τǡ��ޥ����ΤȤ����̤ν�����Ԥʤ�"
;;  (interactive "p")
;;  (if (input-pending-p) (ws-next-line arg)
;;    ("�ޥ��������Х����"))
;;  )
;;-------- �����ޥå���� --------------------------
;;
;;; ^B �����ޥå�
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
;;; ^K �����ޥå�
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
;;; ^Q �����ޥå�
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
;;; ^U �����ޥåפ����
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
;;; ^X �����ޥåפ����
(define-key ctl-x-map "c"    'eval-print-last-sexp)		; ^Pc
;;; �Ĥ����ä��겡���Ƥ��ޤ����Ȥ�¿���Τ� disable ����
(define-key ctl-x-map "\C-c" nil)				; ^P^O

;;;
;;; �����Х륭���ޥåפ����
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
