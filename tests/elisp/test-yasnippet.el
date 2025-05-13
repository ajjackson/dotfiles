(progn
  (find-file "test.py")
  (insert "<inp")
  (yas-expand)
  (cl-assert
   (string-equal
    (buffer-substring 1 20)
    "import numpy as np
"))
  (set-buffer-modified-p nil)
  (kill-current-buffer)
  )
