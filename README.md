ajjackson's new dotfiles
------------------------

Declaring bankruptcy and starting again

Things that worked well last time
=================================

- Org-babel
  - One file for emacs config and one file for everything else actually seemed to be a decent way of dividing

- Using one repository that works for multiple machines (as opposed to previous effort with Git branches)

Things to try differently
=========================

- Public on Github instead of private on bitbucket
  - Bitbucket's new authentication setup is _really_ cumbersome for something I want to clone quickly on a new system and push changes from.
  - I don't really have any secrets in here anyway?

- Ditch the email stuff. I really did prefer notmuch to webmail, but every other aspect of configuration was too painful to keep up, and most of my accounts use Exchange now :-(

- Use elisp to conditionally tangle different stuff on different machines. I was finding it a bit tricky to specify the different use-cases / environments in previous hackery, the extra power should be helpful

- Don't name the setup script setup.py, that was really confusing because of Python conventions

- Use `stow` to distribute files that have system-dependent locations:
    - org-babel can tangle to a standard tree within a temporary director or this source folder
    - then call `stow -t /suitable/root/position [packages]` to copy them
    - `--dotfiles` argument automatically converts "dot-config" to ".config" etc for a nicer tree

- Use Elpaca instead of package.el
  - soooooo much faster
  - install unavailable packages by default, if it shouldn't be on
    this machine then don't configure it (see conditional tangling,
    above...)

Things that remain a bit of a headache
======================================

- It would be really nice if stow could easily be diffed against the current version. Maybe some kind of --dryrun/--diff mode can be added to make.el that handles this. Would need to:
  - Copy current stow files to a temporary directory
  - Re-stow from the temporary directory
  - Tangle files (which is hard-coded to the "main" stow path)
  - Diff the temporarary (and still-live) version with the new tangle
  - Clean up by deleting the newly-tangled files, moving back the temporary stow tree and re-linking everything to the normal path.

- That would be made a lot easier by putting all the stow directories under a folder rather than using the main source directory. It also makes it easier to .gitignore them?


Instructions
============

- For i3 I put a few scripts into ~/.local/bin; make sure those are visible. (i.e. add ~/.local/bin to PATH in ~/.profile)
- `./make.el` to tangle dotfiles to directories
- `stow -t $HOME --dotfiles i3 fish ...` to symlink things to ~/.config and ~/.local/bin
  - Once there are more packages and machines set up, this should be
    included in `make.el`, fired off by an optional argument.

- The [dotfiles feature is busted](https://github.com/aspiers/stow/issues/33)
  on most builds of GNU stow; we can still have dot-filenames but
  directories need to have the literal dot (and so are hard to list
  etc.)

  I was using a fork to get around this but it was more trouble than
  it was worth; for now, we use the mainline stow again.

Containers
==========

An alpine container is defined for unit testing on Github. It can also
be used manually, just follow the same steps as the CI job:
- build image
- run detached container
- archive the project folder and copy it into the container
- attach to container (or run commands with e.g. `podman exec`)
- extract files, run `./make.el` and `stow -t $HOME --dotfiles emacs
  bash ...` to install desired features.
