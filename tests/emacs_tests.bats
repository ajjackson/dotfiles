#! /usr/bin/env -S bats --report-formatter tap

setup_file() {
    # One-time setup: start the emacs daemon
    emacs --daemon=test
}

@test "magit available" {
      emacsclient -s test -e "(magit-version)"
}

@test "ace-window available" {
      emacsclient -s test -e "(ace-window t)"
}

@test "yasnippet" {
      emacsclient -s test -e "(load \"$PWD/tests/elisp/test-yasnippet.el\")"
}

teardown_file() {
    # Kill the emacs daemon
    emacs --batch --exec "(progn (require 'server) (server-eval-at \"test\" '(kill-emacs)))"               
}
