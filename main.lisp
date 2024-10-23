(load (sb-ext:posix-getenv "ASDF"))
(asdf:load-system 'alexandria)
(asdf:load-system 'yason)
(yason:encode
          (list (alexandria:plist-hash-table
                 '("foo" 1 "bar" (7 8 9))
                 :test #'equal)
                2 3 4
                '(5 6 7)
                t nil)
          *standard-output*)
