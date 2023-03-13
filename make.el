#! /usr/bin/env -S emacs -Q --script

(let* ((org-confirm-babel-evaluate nil)
       (this-file (or load-file-name buffer-file-name))
       (this-dir (file-name-directory this-file))
       (dotfiles-org (expand-file-name "dotfiles.org" this-dir)))
  (find-file dotfiles-org)
  (org-babel-goto-named-src-block "guess-system")
  (org-babel-execute-src-block)
  (org-babel-tangle)

  )

(setq argv nil) ; Prevent emacs from trying to visit remaining arguments as files
