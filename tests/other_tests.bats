#! /usr/bin/env -S bats --report-formatter tap

@test "valid TOML files" {
      find . -name "*.toml" | xargs toml-validator
}

@test "shellcheck: no warnings for bash init scripts" {
      echo -e "
      $HOME/.bashrc
      $HOME/.bash_profile
      " | xargs shellcheck --shell bash --severity warning --exclude=1090
}

@test "fish: check syntax of .fish files" {
    find -XL ~/.config -name '*.fish' | xargs -n 1 fish --no-execute
}

@test "git: check git aliases have been added" {
    git alias
}