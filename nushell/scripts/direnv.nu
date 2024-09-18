def direnv [] {
    [
        {
            condition: {|before, after| ($before != $after) and ($after | path join '.env' | path exists) }
            code: r#'
                open .env
                | lines
                | parse --regex '\s*(?P<k>.+?)\s*=\s*?(?P<v>.+)?\s*'
                | reduce --fold {} {|x, acc| $acc | upsert $x.k $x.v}
                | load-env
						'#
        }
    ]
}

export-env {
    $env.config = ( $env.config | upsert hooks.env_change.PWD { |config|
        let o = ($config | get -i hooks.env_change.PWD)
        let val = (direnv)
        if $o == null {
            $val
        } else {
            $o | append $val
        }
    })
}
