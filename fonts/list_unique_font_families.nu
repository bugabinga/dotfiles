ls
| get name
| par-each { fc-scan --format "%{family}\n" $in }
| lines
| parse --regex "^(?<name>[^,\n]+),?.*$"
| get name
| sort
| uniq
