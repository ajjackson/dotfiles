function batdiff --description 'A prettier git diff using bat'
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end
