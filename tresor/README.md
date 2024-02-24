# Tresor

Check your password manager for the mapping of those encrypted files to readable files.
Look in the folder named `Tresor`.

## Encrypting

```nu
java ../tools/aes.java encrypt <input_file> (random uuid)
```

## Decrypting
```nu
java ../tools/aes.java decrypt <encrypted_file> <original_name>
```

> WARN: Take care not to commit decrypted files!
> INFO: Decrypted SSH keys need permission changes: `chmod 400 <key>`
