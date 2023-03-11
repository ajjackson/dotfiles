(setq system
      (let ((hostname (system-name)))
        (cond ((member hostname '("Angel" "Angel.lan" "Angel.local")) "Angel")
              ((member hostname '("ajj-mbp-1" "ajj-mbp-1.local"
                                  "dock-ajj-mbp-1" "dock-ajj-mbp-1.esc.rl.ac.uk"))
               "ajj-mbp-1")
              ('t hostname))
        ))
