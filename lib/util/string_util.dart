class StringUtil {
  static String handleSpecialChar(String str) {
    if (str == null) {
      return "";
    }

    return str.replaceAll("&rdquo;", "」")
        .replaceAll("&ldquo;", "「")
        .replaceAll("&amp;", "&")
        .replaceAll("&quot;", "\"")
        .replaceAll("&mdash;", "-")
        .replaceAll(RegExp("(<em[^>]*>)|(</em>)"), "")
        .replaceAll(RegExp("\n{2,}"), "\n")
        .replaceAll(RegExp("\s{2,}"), " ");
  }
}