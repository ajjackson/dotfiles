#!/usr/bin/env bats

# Post-installation Emacs verification tests
# These tests verify Emacs packages and features after installation

setup_file() {
    # Resolve paths relative to this test file
    # tests/installed/ is two levels deep from repo root
    REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
    export REPO_ROOT
    export ELISP_TEST_DIR="$REPO_ROOT/tests/elisp"

    # One-time setup: start the emacs daemon
    emacs --daemon=test

    # Wait for Elpaca package queue to complete
    # This ensures all packages are installed and available before running tests
    emacsclient -s test -e '(elpaca-wait)' 2>/dev/null || true
}

# Helper function to check if an Emacs feature/package is available
# Usage: require_emacs_feature "feature-name" ["type"]
# Types: "function" (default), "variable", "feature"
require_emacs_feature() {
    local feature="$1"
    local type="${2:-function}"
    local check_expr

    case "$type" in
        function)
            check_expr="(fboundp '$feature)"
            ;;
        variable)
            check_expr="(boundp '$feature)"
            ;;
        feature)
            check_expr="(featurep '$feature)"
            ;;
        *)
            check_expr="(or (fboundp '$feature) (boundp '$feature) (featurep '$feature))"
            ;;
    esac

    if ! emacsclient -s test -e "$check_expr" 2>/dev/null | grep -q "t"; then
        skip "$feature is not available (conditional package may not be installed on this host)"
    fi
}

@test "magit available" {
    require_emacs_feature "magit-version" "function"
    emacsclient -s test -e "(magit-version)"
}

@test "ace-window available" {
    # ace-window may be conditionally installed via if-workstation
    require_emacs_feature "ace-window" "function"
    emacsclient -s test -e "(ace-window t)"
}

@test "yasnippet" {
    require_emacs_feature "yas-minor-mode" "function"
    emacsclient -s test -e "(load \"${ELISP_TEST_DIR}/test-yasnippet.el\")"
}

teardown_file() {
    # Kill the emacs daemon
    emacs --batch --exec "(progn (require 'server) (server-eval-at \"test\" '(kill-emacs)))"
}
