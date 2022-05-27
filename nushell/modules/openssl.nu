# Generate a new ed25519 SSH private key
export def ssh-keygen-ed [
    email: string # Identifier for the COMMENT section of the key
] {
    ssh-keygen -t ed25519 -C $email
}