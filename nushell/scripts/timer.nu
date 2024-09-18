export def main [ input: string ] {

	if (which tclock | is-empty) {
		error make {
			msg: "The program `tclock` is required!"
		}
	}

	if ( $input | is-empty ) {
		error make {
			msg: "timer needs a duration or time"
			label: {
				span: (metadata $input).span
			}
			help: "try 'timer 5min' for example"
		}
	}

	let duration = try { $input | into duration --unit sec }

	if ($duration != null) {
		start_with_duration ( $duration | into string | str replace sec s)
		return
	}

	let time = try { $input | into datetime }

	if ($time != null) {
		start_with_time $time
		return
	}

	error make {
		msg: "The input given is neiter a duration nor a time."
		label: {
			span: (metadata $input).span
		}
		help: "Consult `help into duration` and `help into datetime` for valid input."
	}
}

export def beep [] {
	notify --summary "timer finished" --body "timer is done!" --app-name timer

	for idx in 1..6 {
		seq (random float 100..500) 50 (random float 500..1000) | each { sound make --amplify ( $idx | into float ) $in 144ms }
	}
}

def start_with_duration [ duration: string ] {
	run-external tclock timer '--paused' '--no-millis' '--duration' $duration '--execute' 'nu --commands "use timer.nu; timer beep"'
}

def pad [] {
	fill --width 2 --character 0 --alignment right
}

def start_with_time [ time: datetime ] {
	let time = ($time | into record)
	let time = $"($time.year)-($time.month|pad)-($time.day|pad)T($time.hour|pad):($time.minute|pad):($time.second|pad)($time.timezone)"
	run-external tclock countdown '--title' Timer '--time' $time
	# FIXME: Why can countdown not execute external cmd?
}
