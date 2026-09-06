#!/usr/bin/env bats

# Post-installation Git configuration verification tests
# These tests verify git configuration after dotfiles have been stowed

setup() {
    # Resolve repo root relative to this test file (two levels up from tests/installed/)
    REPO_ROOT="$(dirname "$(dirname "$BATS_TEST_DIRNAME")")"
}

@test "git: check git aliases have been added" {
    # The 'alias' alias is defined in dot-gitconfig to show all configured aliases
    # This test verifies that git config has been properly stowed
    run git alias
    [ "$status" -eq 0 ]
}

@test "git: gitconfig is properly stowed" {
    # Verify that .gitconfig exists and is a symlink or regular file
    [ -f "$HOME/.gitconfig" ]
    
    # Verify that the gitconfig contains expected aliases
    grep -q "\[alias\]" "$HOME/.gitconfig"
    grep -q "lol = log" "$HOME/.gitconfig"
}
