import static java.lang.System.out;

import java.nio.file.*;
import java.nio.charset.*;
import java.nio.*;
import java.io.*;
import java.util.*;

import java.security.*;
import java.security.spec.*;

import javax.crypto.*;
import javax.crypto.spec.*;

class aes {

  enum Command { ENCRYPT, DECRYPT };

  static Cipher AES_GCM_PKCS5;
  static byte[] SALT = new byte[] { 116, 104, 101, 32, 109, 111, 111, 110, 32, 105, 115, 32, 104, 105, 100, 100, 101, 110, 32, 105, 110, 32, 112, 108, 97, 105, 110, 32, 118, 105, 101, 119 };
  static SecureRandom RANDOM = new SecureRandom();
  /*
   * 12 ist NIST recommendation. supposedly fast and secure enough...
   */
  static int GCM_IV_SIZE = 12;
  /*
   * AES encrypts 128-blocks internally, so this should be reasonable memory bufer size.
   */
  static int READ_BUFFER_SIZE = 128;
  /*
   * Supported sizes for GCM authentication tags seem to be {128, 120, 112, 104, 96}.
   * But we do not really care, since we do not use them here. 
   */
  static int GCM_AUTH_TAG_SIZE = 96;

  public static void main(String[] arguments) throws Throwable {
    if(arguments.length == 0){
      usage();
      throw fail();
    }

    var input_command = arguments[0];
    Command command;
    if ("encrypt".startsWith(input_command)) { command = Command.ENCRYPT; }
    else if ("decrypt".startsWith(input_command)) { command = Command.DECRYPT; }
    else { throw fail("unknown command %s given%n", emphasize_global(input_command)); }

    AES_GCM_PKCS5 = Cipher.getInstance("AES/GCM/NoPadding");

    var console = System.console();
    /*
     * If there is no console, this program is most likely part of a pipe.
     * In such cases a `--password-file` flag is mandatory, because we cannot interactively ask for the password.
     */
    if(console == null){
      if(arguments.length != 3 || !"--password-file".equals(arguments[1])) {
        usage();
        throw fail("When running %s non-interactively, the %s flag is required.%nOtherwise there is no way to securely obtain the password.%n",emphasize_local("aes"), emphasize_global("--password-file"));
      }
      var password_file = Path.of(arguments[2]);
      if(!Files.exists(password_file)) { throw fail("the given password file %s does not exist%n", emphasize_local(password_file.toString())); }
      var password = toChars(Files.readAllBytes(password_file));
      switch (command) {
        case ENCRYPT:
          encrypt(password, System.in, System.out);
        break;
        case DECRYPT:
          decrypt(password, System.in, System.out);
        break;
      }
    }
    else {
      if(arguments.length <= 1) {
        usage();
        throw fail("not enough arguments given%n");
      }
      char[] password;
      String input;
      String output;
      if("--password-file".equals(arguments[1])) {
        if(arguments.length != 5) {
          usage();
          throw fail("the flag %s requires a path%n", emphasize_local("--password-file"));
        }
        var password_file = Path.of(arguments[2]);
        if(!Files.exists(password_file)) { throw fail("the given password file %s does not exist%n", emphasize_local(password_file.toString())); }
        password = toChars(Files.readAllBytes(password_file));
        input = arguments[3];
        output = arguments[4];
      }
      else {
        if(arguments.length != 3) {
          usage();
          throw fail("when encrypting/decrypting a file, an output path is required%n");
        }
        password = console.readPassword("[%s]:",emphasize_global("Password"));
        input = arguments[1];
        output = arguments[2];
      }

      var input_path = Path.of(input);
      if(!Files.exists(input_path)) { throw fail("the given input path %s does not exist%n", emphasize_global(input_path.toString())); }
      var output_path = Path.of(output);
      if(Files.exists(output_path)) { throw fail("the output path %s already exists%n", emphasize_global(output_path.toString())); }

      var input_stream = Files.newInputStream(input_path, StandardOpenOption.READ);
      var output_stream = Files.newOutputStream(output_path, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE);

      switch (command) {
        case ENCRYPT:
        encrypt(password, input_stream, output_stream);
        break;
        case DECRYPT:
        decrypt(password, input_stream, output_stream);
        break;
      }
    }

    throw exit();
  }

  static void encrypt(char[] password, InputStream input, OutputStream output) throws Exception {
    // FIXME: generate random salt and append it here just like IV
    // in GCM the IV should be unique per encrypted thingy
    var initialization_vector = new byte[GCM_IV_SIZE];
    RANDOM.nextBytes(initialization_vector);
    //save the IV for the decryption step later. secure? nope. but how else are we to share IVs between encryption/decryption?
    output.write(initialization_vector);
    var secret = toSecretKey(password);
    var parameter_spec = new GCMParameterSpec(GCM_AUTH_TAG_SIZE, initialization_vector);

    AES_GCM_PKCS5.init(Cipher.ENCRYPT_MODE, secret, parameter_spec);
    var read_buffer = new byte[READ_BUFFER_SIZE];
    var aes_buffer = new byte[READ_BUFFER_SIZE];
    int read_bytes_count = 0;
    while((read_bytes_count = input.read(read_buffer)) != -1){
     var aes_bytes_count = AES_GCM_PKCS5.update(read_buffer, 0, read_bytes_count, aes_buffer); 
     output.write(aes_buffer, 0, aes_bytes_count);
    }
    output.write(AES_GCM_PKCS5.doFinal());
  }

  static void decrypt(char[] password, InputStream input, OutputStream output) throws Exception {
    //the IV get prepended to the data during encryption
    var initialization_vector = new byte[GCM_IV_SIZE];
    input.read(initialization_vector);
    var parameter_spec = new GCMParameterSpec(GCM_AUTH_TAG_SIZE, initialization_vector);
    var secret = toSecretKey(password);

    AES_GCM_PKCS5.init(Cipher.DECRYPT_MODE, secret, parameter_spec);
    var read_buffer = new byte[READ_BUFFER_SIZE];
    var aes_buffer = new byte[READ_BUFFER_SIZE];
    int read_bytes_count = 0;
    while((read_bytes_count = input.read(read_buffer)) != -1){
     var aes_bytes_count = AES_GCM_PKCS5.update(read_buffer, 0, read_bytes_count, aes_buffer); 
     output.write(aes_buffer, 0, aes_bytes_count);
    }
    //FIXME: the java impl of GCM seems to buffer the whole data in memory and only releasing it on doFinal. yuck!
    //TODO: in the case of AES GCM the final byte block is the authentication tag.
    //as such it should porbably NOT be written to the output file.
    //or is this assumption wrong?
    output.write(AES_GCM_PKCS5.doFinal());
    //FIXME: when given a wrong password we get a nonsensical error. make this nicer for human
  }

  static SecretKey toSecretKey(char[] password) throws Exception {
    var factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
    var spec = new PBEKeySpec(password, SALT, 65536, 256);
    return new SecretKeySpec(factory.generateSecret(spec).getEncoded() , "AES");
  }

  static char[] toChars(byte[] bytes) {
    var byte_buffer = ByteBuffer.wrap(bytes);
    var char_buffer = StandardCharsets.UTF_8.decode(byte_buffer);
    return char_buffer.array();
  }

  static void usage() {
    out.printf("%s encrypts/decrypts data.%n", emphasize_local("Symmetrically "));
    out.printf("%s: java aes.java <e(ncrypt)|d(ecrypt)> [--password-file <path>] <input path> <output path>%n", emphasize_global("Usage for files"));
    out.printf("%s: java aes.java <e(ncrypt)|d(ecrypt)> --password-file <path>%n", emphasize_global("Usage for stdin/stdout"));
  }

  static Throwable exit() {
    out.printf("%s!%n", emphasize_local("Done"));
    System.exit(0);
    //abuse control flow to make compiler realize `exit` will never return
    return new Throwable(); 
  }

  static String emphasize_global(String message) {
    return "\033[4m" + message + "\033[0m";
  }

  static String emphasize_local(String message) {
    return "\033[3m" + message + "\033[0m";
  }

  static Throwable fail(String message, Object... arguments) {
    out.printf(message, arguments);
    System.exit(-1);
    //abuse control flow to make compiler realize `exit` will never return
    return new Throwable(); 
  }

  static Throwable fail() {
    System.exit(-1);
    //abuse control flow to make compiler realize `exit` will never return
    return new Throwable(); 
  }
}
