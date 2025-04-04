#! /usr/bin/env sh

emacs --daemon=installer

emacsclient -s installer -e "(elpaca-wait)"

emacs --batch --exec "(progn (require 'server) (server-eval-at \"installer\" '(kill-emacs)))"
