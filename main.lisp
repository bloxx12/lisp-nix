(load (sb-ext:posix-getenv "ASDF"))
(asdf:load-system 'alexandria)
(asdf:load-system 'yason)

(yason:encode

(alexandria:plist-hash-table
                 '("y" 1 "x" (7 8 9))
                 :test #'equal)
                 ;         (list (alexandria:plist-hash-table
                 ; '("foo" 1 "bar" (7 8 9))
                 ; :test #'equal))
          *standard-output*)
