#!/usr/bin/env bats

setup() {
    # Find tangled em_wrap location (e.g. in emacs/.local/bin or fish/.local/bin)
    EM_WRAP="$(find . -name em_wrap -type f | head -n 1)"

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
    ! grep "LD_PRELOAD=" bash/dot-bashrc 2>/dev/null || true
    ! grep -E "export EDITOR=.*(-t|-c|LD_PRELOAD)" bash/dot-bash_profile 2>/dev/null
    grep -E "export EDITOR=.*em_wrap" bash/dot-bashrc bash/dot-bash_profile
}

@test "bash & fish: alias em to em_wrap" {
    grep -E "alias em=.*em_wrap" bash/dot-bashrc
    grep -E "alias em.*em_wrap" fish/.config/fish/config.fish
}
