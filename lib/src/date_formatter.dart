class DateFormatter {
  /// Basic dd-MM-yyyy
  static String formatDate(DateTime date) {
    return "${_twoDigits(date.day)}-"
        "${_twoDigits(date.month)}-"
        "${date.year}";
  }

  /// Custom pattern formatter
  /// Supported tokens:
  /// dd, MM, yyyy, HH, mm, ss
  static String format(DateTime date, String pattern) {
    return pattern
        .replaceAll('dd', _twoDigits(date.day))
        .replaceAll('MM', _twoDigits(date.month))
        .replaceAll('yyyy', date.year.toString())
        .replaceAll('HH', _twoDigits(date.hour))
        .replaceAll('mm', _twoDigits(date.minute))
        .replaceAll('ss', _twoDigits(date.second));
  }

  /// Parse string to DateTime (supports dd-MM-yyyy)
  static DateTime parse(String dateString) {
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw FormatException("Invalid date format. Expected dd-MM-yyyy");
    }

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  /// Convert date from one format to another
  /// Example:
  /// convert("12-02-2026", "dd-MM-yyyy", "yyyy/MM/dd")
  static String convert(
      String dateString, String fromPattern, String toPattern) {
    final date = parseWithPattern(dateString, fromPattern);
    return format(date, toPattern);
  }

  /// Parse using pattern (limited support)
  static DateTime parseWithPattern(String dateString, String pattern) {
    final separator = _detectSeparator(pattern);
    final patternParts = pattern.split(separator);
    final dateParts = dateString.split(separator);

    int day = 1, month = 1, year = 1970;

    for (int i = 0; i < patternParts.length; i++) {
      switch (patternParts[i]) {
        case 'dd':
          day = int.parse(dateParts[i]);
          break;
        case 'MM':
          month = int.parse(dateParts[i]);
          break;
        case 'yyyy':
          year = int.parse(dateParts[i]);
          break;
      }
    }

    return DateTime(year, month, day);
  }

  /// Human readable time ago
  static String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }

  /// ISO 8601 format
  static String toIso(DateTime date) {
    return date.toIso8601String();
  }

  /// Start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// End of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // -------------------------
  // Private helper methods
  // -------------------------

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  static String _detectSeparator(String pattern) {
    if (pattern.contains('-')) return '-';
    if (pattern.contains('/')) return '/';
    if (pattern.contains('.')) return '.';
    throw FormatException("Unsupported date separator");
  }
}
