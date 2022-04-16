
# Opens the given resource in the operating systems preferred application.
export def start [
    ...rest: string # Paths or URLs the OS should open for you.
] {
    if $env.WIN32? {
        $rest | each { |thing| ^start $thing}
    } else {
        $rest | each { |thing| ^xdg-open $thing }
    }
}