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

teardown_file() {
    # Kill the emacs daemon
    emacs --batch --exec "(progn (require 'server) (server-eval-at \"test\" '(kill-emacs)))"               
}
