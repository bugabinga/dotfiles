export def main [
	url: path
] {
	let basename = ( $url | path basename )
	http get $url | save --raw $basename
}
