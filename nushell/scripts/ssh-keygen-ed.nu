# Generate a new ed25519 SSH private key
export def main [
    email: string # Identifier for the COMMENT section of the key
] {
    ssh-keygen -t ed25519 -C $email
}
