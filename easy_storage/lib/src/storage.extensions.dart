extension EasyStorageStringExtenions on String {
  /// https://firebasestorage.googleapis.com/v0/b/grc-30ca7.appspot.com/o/users%2FNx85sXadVXT7KDSgD5SY132B4z42%2Fpexels-alejandro-navarrete-gonzalez-6959712.jpg?alt=media&token=bd30c81a-eb7d-4c17-ac58-9285b037fe51
  String get thumbnail {
    String u = this;
    u = u.replaceFirst(RegExp(".WEBP", caseSensitive: false), "_200x200.webp");
    u = u.replaceFirst(RegExp(".JPG", caseSensitive: false), "_200x200.webp");
    u = u.replaceFirst(RegExp(".JPEG", caseSensitive: false), "_200x200.webp");
    u = u.replaceFirst(RegExp(".PNG", caseSensitive: false), "_200x200.webp");
    u = u.replaceFirst(RegExp(".GIF", caseSensitive: false), "_200x200.webp");
    return u;
  }

  String get thumbnailMedium {
    String u = this;
    u = u.replaceFirst(RegExp(".WEBP", caseSensitive: false), "_600x600.webp");
    u = u.replaceFirst(RegExp(".JPG", caseSensitive: false), "_600x600.webp");
    u = u.replaceFirst(RegExp(".JPEG", caseSensitive: false), "_600x600.webp");
    u = u.replaceFirst(RegExp(".PNG", caseSensitive: false), "_600x600.webp");
    u = u.replaceFirst(RegExp(".GIF", caseSensitive: false), "_600x600.webp");
    return u;
  }

  String get thumbnailLarge {
    String u = this;
    u = u.replaceFirst(
        RegExp(".WEBP", caseSensitive: false), "_1200x1200.webp");
    u = u.replaceFirst(RegExp(".JPG", caseSensitive: false), "_1200x1200.webp");
    u = u.replaceFirst(
        RegExp(".JPEG", caseSensitive: false), "_1200x1200.webp");
    u = u.replaceFirst(RegExp(".PNG", caseSensitive: false), "_1200x1200.webp");
    u = u.replaceFirst(RegExp(".GIF", caseSensitive: false), "_1200x1200.webp");
    return u;
  }
}
