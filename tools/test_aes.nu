rm -f aes.java.enc
rm -f aes.java.dec
java aes.java en --password-file pipi.pass aes.java aes.java.enc
java aes.java de --password-file pipi.pass aes.java.enc aes.java.dec

delta aes.java aes.java.dec
