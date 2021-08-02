import static java.lang.System.*;

import java.awt.*;
import java.awt.datatransfer.*;
import java.io.*;
import java.util.*;

class random_uuid {
  public static void main(String[] __) {
    out.println("The following random UUID has been copied to the clipboard!");
    var uuid = UUID.randomUUID();
    out.println(uuid);
    var clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    var content = new StringSelection(uuid.toString());
    clipboard.setContents(content, content);
  }
}
