export def github-upload-key [
  title: string # Name the key, so you will remember what it is used for
  key: path     # Path to the PUBLIC key
] {
  if ($key | path exists) {
    echo (build-string "uploading ssh public key " (ansi gi) $key (ansi reset) " with title " (ansi gb) $title (ansi reset) " to GitHub.") 
    echo (char newline)
    let encrypted_token_path = (build-string $env.DOTFILES / tresor / 4cef0ce3-da3a-4f16-9412-2d094b4f7445)
    let decrypted_token_path = (build-string $env.DOTFILES / tresor / gh_token)
    aes decrypt $encrypted_token_path $decrypted_token_path 
    let token = (open --raw $decrypted_token_path)
    let key_content = (open --raw $key)
    rm -f $decrypted_token_path
    let result = (do -i { xh --bearer $token https://api.github.com/user/keys (build-string title = $title) (build-string key = $key_content) | from json})
    if ($result | has-column? errors) {
      let message = ($result | get message)
      let url = ($result | get documentation_url)
      let errors = ($result | get errors)
      echo (build-string (ansi rb) $message (ansi reset) (char newline))
      echo (char newline)
      $errors | each {
        | it |
        let resource = ($it | get resource)
        let code = ($it | get code)
        let field = ($it | get field)
        let message = ($it | get message)
        echo (build-string (ansi ui) $resource : $code : $field ": " (ansi rb) $message (ansi reset) (char newline))
      }
      echo (build-string "Further information: " (ansi yi) $url (ansi reset) (char newline))
    } else {
      let id = ($result | get id)
      let key = ($result | get key)
      let title = ($result | get title)
      let created_at = ($result | get created_at)
      echo (build-string "[" ID : $id "]" " key with title " (ansi gb) $title (ansi reset) " was created at " (ansi yi) $created_at (ansi reset) "." (char newline) )
      echo (build-string (ansi wu) "PUBLIC SSH KEY:" (ansi reset))
      echo (char newline)
      echo ($key | ansi gradient --fgstart 0xaefe9f --fgend 0xfefefe)
      echo (char newline)
    }
  } else {
    echo (build-string "key " (ansi rb) $key (ansi reset) " not found!")
    echo (char newline)
  }
}

# Shows git log in a pretty table
export def glog [
  ...rest: string # Extra arguments to git log
] {
  git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n 25 $rest | lines | split column "»¦«" commit subject name email date | update date { get date | into datetime} | sort-by date
}

# Show the effective configuration of git
export def git-effective-config [] {
  git config --list --show-origin
}

export alias ghead = git rev-parse HEAD
