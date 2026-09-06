#!/usr/bin/env bats

# Isolated unit tests for editor wrapper with mocked dependencies
# These tests use mocked emacsclient to verify behavior without requiring Emacs

setup() {
    # Resolve repo root relative to this test file (two levels up from tests/unit/)
    REPO_ROOT="$(dirname "$(dirname "$BATS_TEST_DIRNAME")")"
    EM_WRAP="$REPO_ROOT/emacs/dot-local/bin/em_wrap"

    # Create temp directory for mock emacsclient
    MOCK_DIR="$(mktemp -d)"
    cat << 'EOF' > "$MOCK_DIR/emacsclient"
#!/bin/sh
echo "MOCK_LD_PRELOAD=$LD_PRELOAD"
echo "MOCK_ARGS=$*"
exit 0
EOF
    chmod +x "$MOCK_DIR/emacsclient"
    ORIG_PATH="$PATH"
    export PATH="$MOCK_DIR:$PATH"
}

teardown() {
    export PATH="$ORIG_PATH"
    rm -rf "$MOCK_DIR"
}

@test "em_wrap: is generated, executable, and uses sh shebang" {
    [ -n "$EM_WRAP" ]
    [ -x "$EM_WRAP" ]
    head -n 1 "$EM_WRAP" | grep -E "^#! */(bin/sh|usr/bin/env sh)"
}

@test "em_wrap: falls back to -c when not on a tty" {
    run "$EM_WRAP" testfile.txt < /dev/null
    [ "$status" -eq 0 ]
    echo "$output" | grep "MOCK_ARGS=-c testfile.txt"
}

@test "em_wrap: uses -s when INSIDE_EMACS with server name" {
    INSIDE_EMACS=1 EMACS_SERVER_NAME="test-server" run "$EM_WRAP" testfile.txt < /dev/null
    [ "$status" -eq 0 ]
    echo "$output" | grep "MOCK_ARGS=-s test-server testfile.txt"
}

@test "em_wrap: errors when INSIDE_EMACS is set without server name" {
    INSIDE_EMACS=1 EMACS_SERVER_NAME="" run "$EM_WRAP" testfile.txt
    [ "$status" -ne 0 ]
    echo "$output" | grep "EMACS_SERVER_NAME not set"
}

@test "bash: EDITOR does not contain LD_PRELOAD or flags" {
    ! grep "LD_PRELOAD=" "$REPO_ROOT/bash/dot-bashrc" 2>/dev/null || true
    ! grep -E "export EDITOR=.*(-t|-c|LD_PRELOAD)" "$REPO_ROOT/bash/dot-bash_profile" 2>/dev/null
    grep -E "export EDITOR=.*em_wrap" "$REPO_ROOT/bash/dot-bashrc" "$REPO_ROOT/bash/dot-bash_profile"
}

@test "bash & fish: alias em to em_wrap" {
    grep -E "alias em=.*em_wrap" "$REPO_ROOT/bash/dot-bashrc"
    grep -E "alias em.*em_wrap" "$REPO_ROOT/fish/.config/fish/config.fish"
}
