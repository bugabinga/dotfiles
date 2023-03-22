# Check whether table in pipeline has a column with given name
export def "has-column?" [
  name: string # Name of the column to check for
] {
    transpose | values | get 0 | any { |column| $column == $name }
}

# Flattens a table into a string separated by a single space character.
export def to-string [] { flatten | into string | str collect ' ' }

