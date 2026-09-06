# Test runner targets for dotfiles

# Run all tests (local development)
test:
    @echo "Running all test suites..."
    just test-static
    just test-unit
    just test-installed

# Run static analysis tests (local development)
test-static:
    @echo "Running static tests..."
    bats tests/static/

# Run unit tests (local development)
test-unit:
    @echo "Running unit tests..."
    bats tests/unit/

# Run installed environment tests (local development)
test-installed:
    @echo "Running installed environment tests..."
    bats tests/installed/

# Run all tests with TAP output for CI
test-ci:
    bats tests/static/ tests/unit/ tests/installed/ --report-formatter tap -j 4