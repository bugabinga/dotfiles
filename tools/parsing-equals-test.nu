def main [] {
    assert-is-a { "" } string
    assert-is-a { "=" } string
    assert-is-a { "-" } string
    assert-is-a { "-=" } string
    assert-is-a { "-=-" } string
    assert-is-a { "=-" } string

    assert-is-a { [""] } list<string>
    assert-is-a { ["="] } list<string>
    assert-is-a { ["-"] } list<string>
    assert-is-a { ["-="] } list<string>
    
    # error: unknown command
    #assert-is-a { ["-=-"] } list<string>
    #assert-is-a { ["=-"] } list<string> 
    #assert-is-a { ["=-"] } list<string>

    assert-is-a { ["= "] } list<string>
    assert-is-a { [ "="] } list<string>
    assert-is-a { ["=" ] } list<string>
    assert-is-a { [ "=" ] } list<string>

    assert-is-a { [ "=OK" ] } list<string>
}

def assert-is-a [
    code: block           # some nu expression
    expected_type: string # expected nu type of given expression, as printed by `describe`
] {
    let span = (metadata $code).span;
    let actual_type = ( do $code | describe )
    if $actual_type == $expected_type {
        echo $"(char sun)\t(ansi green_bold)OK(ansi reset)\t($actual_type)"
    } else {
        error make {
            msg: $"(char cloud)\t(ansi red_bold)FAIL(ansi reset)",
            label: {
                text: $"expected a `($expected_type)` but got a `($actual_type)`",
                start: $span.start,
                end: $span.end
            }
        }
    }
}