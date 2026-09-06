#!/usr/bin/env bats

# Static checks for dotfiles repository
# These tests validate syntax and structure without requiring installation

setup() {
    # Resolve repo root relative to this test file (two levels up from tests/static/)
    REPO_ROOT="$(dirname "$(dirname "$BATS_TEST_DIRNAME")")"
}

@test "valid TOML files" {
    # Find and validate all TOML files in the repository
    run sh -c "find '$REPO_ROOT' -name '*.toml' | xargs toml-validator"
    [ "$status" -eq 0 ]
}

@test "shellcheck: no warnings for bash init scripts" {
    # Run shellcheck on bash init scripts in the repo
    # These are the dot-prefixed files that will be stowed as ~/.bashrc and ~/.bash_profile
    run shellcheck --shell bash --severity warning --exclude=1090 \
        "$REPO_ROOT/bash/dot-bashrc" \
        "$REPO_ROOT/bash/dot-bash_profile"
    [ "$status" -eq 0 ]
}

@test "shellcheck: no warnings for tangled scripts" {
    # Run shellcheck on scripts generated from dotfiles.org (tangled scripts)
    run shellcheck --shell bash --severity warning \
        "$REPO_ROOT/emacs/dot-local/bin/em_wrap"
    [ "$status" -eq 0 ]
}

@test "fish: check syntax of .fish files" {
    # Use portable find -L flag (not macOS-specific -XL)
    # Check all .fish files in the repository
    run sh -c "find -L '$REPO_ROOT/fish' -name '*.fish' | xargs -n 1 fish --no-execute"
    [ "$status" -eq 0 ]
}

@test "fish config: check indentation and quoting" {
    # Verify fish config has proper indentation and quoting
    run fish_indent "$REPO_ROOT/fish/.config/fish/config.fish"
    [ "$status" -eq 0 ]
    
    # Compare indented output with original to ensure consistency
    run diff <(fish_indent "$REPO_ROOT/fish/.config/fish/config.fish") "$REPO_ROOT/fish/.config/fish/config.fish"
    [ "$status" -eq 0 ]
}
