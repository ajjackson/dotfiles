ajjackson's new dotfiles
------------------------

Declaring bankruptcy and starting again.

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

    - Consider using `stow` to distribute files that have system-dependent locations:
        - org-babel can tangle to a standard tree within a temporary director or this source folder
        - then call `stow -t /suitable/root/position` to copy them

Things that remain a bit of a headache
======================================

    - Warnings/errors from uninstalled emacs packages.