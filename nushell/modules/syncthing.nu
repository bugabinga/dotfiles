export def "conflicts list" [] {
  fd --hidden --no-ignore sync-conflict $env.HOME |
  lines |
  filter { |path| not ($path =~ "/Trash/") }
}

export def "conflicts merge" [] {
  (conflicts list) |
  each { |conflict| 
    merge ( to_original $conflict ) $conflict
    let input = ( input $"Merge successful? \((ansi pb)Y(ansi reset)/n\) \n" )
    let sanitize = ( $input | str trim | str downcase | str substring 0..1 )
    if ($sanitize | is-empty) or $sanitize == 'y' {
      rm --verbose --interactive $conflict
    } else {
      $conflict
    }
  }
}

export def "conflicts diff" [] {
  (conflicts list) |
  each { |conflict| 
    diff ( to_original $conflict ) $conflict
  }
}

def parse-sync-conflict [] {
  parse -r '(?<filename>.*)\.sync-conflict-(?<date>.\d+)-(?<time>.\d+)-(?<id>\w+)\.?(?<extension>.*)?'
}

def to_original [ file: path ] {
  let conflict = ( $file | parse-sync-conflict )
  mut filename = ($conflict | get filename.0)
  let extension = ($conflict | get extension.0)
  if not ($extension | is-empty) { 
    $filename = $filename + '.' + $extension
  }
  $filename
}

def diff [ a: path, b: path ] {
  print $"diffing ($a) and ($b)"
  ^difft $a $b
}
def merge [ a: path, b: path ] {
  meld $a $b
}
