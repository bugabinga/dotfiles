import static java.lang.System.out;
import static java.lang.System.err;
import static java.lang.System.in;

import java.nio.file.*;
import java.nio.charset.*;
import java.security.*;
import java.io.*;
import java.util.*;
import java.util.function.*;
import java.util.stream.*;

/**
 *  <h1>sha CLI</h1>
 *  <p>
 *  This command line tool generates cryptographic check sums for any given input.
 *  Supported algorithms are:
 *  <ul>
 *  <li> MD5
 *  <li> SHA-1
 *  <li> SHA-224
 *  <li> SHA-256
 *  <li> SHA-384
 *  <li> SHA-512
 *  <li> SHA3-224
 *  <li> SHA3-256
 *  <li> SHA3-384
 *  <li> SHA3-512
 *  </ul>
 *  <p>
 *  Usage: The first argument to the coommand must be a specifier for the algorithm, that is to be used.
 *  The specifier will be fuzzily matched on a best effort basis, so that humans do not have to remember
 *  exact specifiers.
 *  For example, 'md' will match 'MD5', 'sha' and 'sh' will match 'SHA-1', '512' will match 'SHA-512' and
 *  so on.
 *  <p>
 *  The second input can either be a path to a file, in which case its contents will be checksummed, or an
 *  arbitrary string.
 *  If the second input is not given, it is assumed to take the <code>standard input stream</code> as input.
 *  An error will occur, if the <code>stdin</code> is empty in such a case.
 *  <p>
 *  The output of the command will be the checksum with the selected algorithm prefixed, seperated by a ':'.
 *  Ex: <code>sha512:12A447B5954E0AF6FB0A6E95779EAE3151B09EFF9EFADBB23F116294674A19E861A3FCCDC3EC8A445C814BB3A3A93603A74D07B4E397B7D66E22211AD67943C3</code>
 */
class sha {
  public static void main(String[] command_line_arguments) throws Exception {
    if(command_line_arguments.length == 0)
    {
      err.println("no input given");
      help();
      throw fail();
    }
    if(command_line_arguments.length > 2)
    {
      err.println("too many inputs given");
      help();
      throw fail();
    }
    if(command_line_arguments.length == 1)
    {
      var algorithm = guess_algorithm(command_line_arguments[0]);
      print_checksum(algorithm, in);
    }
    else if(command_line_arguments.length == 2)
    {
      var algorithm = guess_algorithm(command_line_arguments[0]);
      var input = command_line_arguments[1];
      var path = as_valid_path(input);
      if(path != null)
      {
        print_checksum(algorithm, path_to_stream(path));
      }
      else
      {
        print_checksum(algorithm, string_to_stream(input));
      }
    }
  }

  private static MessageDigest guess_algorithm(String guess) throws Exception
  {
    var available_algorithms = new String[]{"MD5", "SHA-1", "SHA-224", "SHA-256", "SHA-384", "SHA-512", "SHA3-224", "SHA3-256", "SHA3-384", "SHA3-512"};
    var highest_scoring_algorithm_index = 0;
    var highest_score = 0;
    //we iterate the algorithms in reverse, so that later algos get prio in case of equal scores
    for(int i = available_algorithms.length-1; i >= 0; --i)
    {
      var score = guess_score(available_algorithms[i], guess);
      if(score > highest_score)
      {
        highest_score = score;
        highest_scoring_algorithm_index = i;
      }
    }
    if(highest_score == 0)
    {
      err.println("the given algorithm '"+ guess +"' could not be matched with any of: "+ Arrays.toString(available_algorithms));
      help();
      throw fail();
    }
    return MessageDigest.getInstance(available_algorithms[highest_scoring_algorithm_index]);
  }

  private static int guess_score(String name, String guess){
    /*
     * we start by rating every guess with the max score.
     * subsequent transformations of the name and comparisons with the guess lower the score by half.
     * if a comparison yields true, we return the current score.
     * if no comparison yields true, the score is 0.
     */
    var normalized_guess = guess.toLowerCase().strip();
    var transformed_name = name;
    var score = Integer.MAX_VALUE;
    //the first comparison uses only stripped guess, in case human bothered to enter the algorithm exactly correct
    if(transformed_name.equals(guess.strip()))
    {
      return score;
    }
    score = score / 2;
    transformed_name = transformed_name.toLowerCase();
    if(transformed_name.equals(normalized_guess))
    {
      return score;
    }
    score = score / 2;
    transformed_name = transformed_name.replaceAll("-","");
    if(transformed_name.equals(normalized_guess))
    {
      return score;
    }
    score = score / 2;
    if(transformed_name.endsWith(normalized_guess))
    {
      return score;
    }
    score = score / 2;
    if(transformed_name.startsWith(normalized_guess))
    {
      return score;
    }
    score = score / 2;
    if(transformed_name.contains(normalized_guess))
    {
      return score;
    }
    return 0;
  }

  private static void print_checksum(MessageDigest algorithm, InputStream input_stream) throws IOException
  {
    byte [] buffer = new byte[4092];
    while( (buffer = input_stream.readNBytes(4092)).length > 0 )
    {
      algorithm.update(buffer);
    }
    out.println(algorithm.getAlgorithm() + ":" + bytesToHex(algorithm.digest()));
  }

  private static Path as_valid_path(String path)
  {
    try
    {
      var real_path = Path.of(path);
      if(
        Files.exists(real_path) &&
        Files.isReadable(real_path) &&
        Files.isRegularFile(real_path)
      )
      {
        return real_path;
      }
    }
    catch(InvalidPathException __)
    {
      //do nothing if path is invalid
    }
    return null;
  }

  private static InputStream path_to_stream(Path path) throws IOException
  {
    return Files.newInputStream(path);
  }

  private static InputStream string_to_stream(String string)
  {
    return new ByteArrayInputStream(string.getBytes());
  }

  private static String bytesToHex(byte[] bytes) {
    byte[] HEX_ARRAY = "0123456789ABCDEF".getBytes(StandardCharsets.US_ASCII);
    byte[] hexChars = new byte[bytes.length * 2];
    for (int i = 0; i < bytes.length; i++)
    {
      int v = bytes[i] & 0xFF;
      hexChars[i * 2] = HEX_ARRAY[v >>> 4];
      hexChars[i * 2 + 1] = HEX_ARRAY[v & 0x0F];
    }
    return new String(hexChars, StandardCharsets.UTF_8);
}
  private static void help()
  {
    out.println("Generate cryptographic checksum");
    out.println("");
    out.println("Usage:");
    out.println("\t> sha <algorithm> <string>");
    out.println("\t> sha <algorithm> <path>");
    out.println("\t> cat somefile.txt | sha <algorithm>");
    out.println("");
    out.println("Algorithms:");
    out.println("\t- md5");
    out.println("\t- sha1");
    out.println("\t- sha224");
    out.println("\t- sha256");
    out.println("\t- sha384");
    out.println("\t- sha512");
    out.println("\t- sha3-224");
    out.println("\t- sha3-256");
    out.println("\t- sha3-384");
    out.println("\t- sha3-512");
  }

  private static Exception fail() {
    System.exit(-1);
    /*
     * This is in fact dead code, but a neat trick to misuse the throw keyword for control flow.
     * Since the compiler has no concept of a terminating function, like System.exit, we fake it by
     * pretending this function throws.
     */
    return new RuntimeException();
  }
}
