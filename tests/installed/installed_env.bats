#!/usr/bin/env bats

# Post-installation environment verification tests
# These tests verify that dotfiles have been properly stowed into $HOME

setup() {
    # Resolve repo root relative to this test file
    # tests/installed/ is two levels deep from repo root
    REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
}

@test "installed: ~/.local/bin/em_wrap resolves to repo emacs build" {
    [ -x "$HOME/.local/bin/em_wrap" ]
    [ "$(readlink -f "$HOME/.local/bin/em_wrap")" = "$(readlink -f "$REPO_ROOT/emacs/dot-local/bin/em_wrap")" ]
}

@test "installed: em_wrap is discoverable on PATH in bash login shell" {
    bash -l -c 'command -v em_wrap'
}

@test "installed: em_wrap is discoverable on PATH in fish shell" {
    if ! command -v fish >/dev/null 2>&1; then
        skip "fish is not installed"
    fi
    fish -c 'command -v em_wrap'
}
