(("local" @keyword) (#set! conceal "⋅"))
(("function" @keyword.function) (#set! conceal "ϝ"))
(("end" @keyword.function) (#set! conceal "∎"))
(("return" @keyword.return) (#set! conceal "↳"))
(("then" @conditional) (#set! conceal "⟶"))

((dot_index_expression table: (identifier) @variable (#eq? @variable "vim")) (#set! conceal ""))

((function_call name: (identifier) @function (#eq? @function "require")) (#set! conceal ""))

; ((function_call name: (identifier) @function (#eq? @function "want")) (#set! conceal "ω"))
; ((local_declaration name: (identifier) @variable (#eq? @variable "want") (#set! conceal "ω"))
