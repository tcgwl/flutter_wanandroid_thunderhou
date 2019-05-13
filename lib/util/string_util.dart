class StringUtil {
  static String handleSpecialChar(String str) {
    if (str == null) {
      return "";
    }

    return str.replaceAll("&rdquo;", "」")
        .replaceAll("&ldquo;", "「")
        .replaceAll("&amp;", "&")
        .replaceAll("&quot;", "\"")
        .replaceAll("&mdash;", "-");
  }
}