;; inherits: lua
;; extends
(("local" @keyword) (#set! conceal "·"))
(("function" @keyword.function) (#set! conceal "λ"))
(("return" @keyword.return) (#set! conceal "󰌑"))
