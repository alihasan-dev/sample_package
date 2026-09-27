import '../enums.dart';

extension StringFormatterExtension on String {

  bool get isBlank => trim().isEmpty;

  // String get reverse {
  //   final input = this;
  //   if (input.isBlank) return '';
  //   final inputlist = input.split('');
  //   int start = 0;
  //   int end = inputlist.length - 1;
  //   while (start < end) {
  //     final temp = inputlist[start];
  //     inputlist[start] = inputlist[end];
  //     inputlist[end] = temp;
  //     start+=1;
  //     end-=1;
  //   }
  //   return inputlist.join('');
  // }

  /// Reverses the string, correctly handling multi-code-unit characters
  /// (emoji, combining marks) by reversing over [runes] rather than chars.
  String get reverse => String.fromCharCodes(runes.toList().reversed);

  bool equalsIgnoreCase(String b) {
    final a = this;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      int codeA = a.codeUnitAt(i);
      int codeB = b.codeUnitAt(i);
      if (codeA != codeB) {
        if (codeA >= 65 && codeA <= 90) codeA += 32;
        if (codeB >= 65 && codeB <= 90) codeB += 32;
        if (codeA != codeB) return false;
      }
    }
    return true;
  }

  /// Capitalizes only the first letter of the string, lowercases the rest.
  ///
  /// `'hELLO'.capitalize()` -> `'Hello'`
  String get capitalize {
    final str = this;
    if (str.isBlank) return str;
    return '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of every word, leaving the rest of each
  /// word untouched (unlike [capitalize], which lowercases the remainder).
  ///
  /// `'the quick BROWN fox'.toTitleCase()` -> `'The Quick BROWN Fox'`
  String get toTitleCase {
    if (isEmpty) return this;
    return split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w.capitalize)
        .join(' ');
  }

  /// Converts to `camelCase`. Understands spaces, `_`, `-`, and existing
  /// camelCase/PascalCase boundaries as word separators.
  ///
  /// `'user_first_name'.toCamelCase()` -> `'userFirstName'`
  /// `'user-first-name'.toCamelCase()` -> `'userFirstName'`
  /// `'UserFirstName'.toCamelCase()` -> `'userFirstName'`
  String toCamelCase() {
    final input = this;
    final words = input.splitIntoWords;
    if (words.isEmpty) return '';
    final first = words.first.toLowerCase();
    final rest = words.skip(1).map((item) => item.capitalize).join();
    return first + rest;
  }

  /// Converts to `kebab-case`.
  ///
  /// `'userFirstName'.toKebabCase()` -> `'user-first-name'`
  String get toKebabCase {
    final input = this;
    final words = input.splitIntoWords;
    return words.map((w) => w.toLowerCase()).join('-');
  }

  /// Converts to `CONSTANT_CASE`.
  ///
  /// `'userFirstName'.toConstantCase()` -> `'USER_FIRST_NAME'`
  String get toConstantCase {
    final words = splitIntoWords;
    return words.map((w) => w.toUpperCase()).join('_');
  }

  /// Flips the case of every character.
  ///
  /// `'Hello World'.toggleCase()` -> `'hELLO wORLD'`
  String get toggleCase {
    final buffer = StringBuffer();
    for (final rune in runes) {
      final char = String.fromCharCode(rune);
      final upper = char.toUpperCase();
      final lower = char.toLowerCase();
      if (char == upper && char != lower) {
        buffer.write(lower);
      } else {
        buffer.write(upper);
      }
    }
    return buffer.toString();
  }

  /// Collapses runs of whitespace into a single space and trims the ends.
  ///
  /// `'  Hello   World  '.removeExtraSpaces()` -> `'Hello World'`
  String get removeExtraSpaces => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Removes everything that isn't a letter or digit. Set [keepSpaces] to
  /// preserve whitespace.
  ///
  /// `'Hello, World! 123'.removeSpecialCharacters()` -> `'Hello World 123'`
  String removeSpecialCharacters({bool keepSpaces = true}) {
    final pattern = keepSpaces ? RegExp(r'[^a-zA-Z0-9\s]') : RegExp(r'[^a-zA-Z0-9]');
    final cleaned = replaceAll(pattern, keepSpaces ? '' : '');
    return keepSpaces ? cleaned.removeExtraSpaces : cleaned;
  }

  /// True if every character is a digit and the string is non-empty.
  bool get isNumeric => !isBlank && RegExp(r'^[0-9]+$').hasMatch(this);

  /// True if every character is an ASCII letter and the string is non-empty.
  bool get isAlpha => !isBlank && RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// True if every character is an ASCII letter or digit.
  bool get isAlphanumeric => !isBlank && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Number of words, splitting on whitespace.
  int get wordCount => isBlank
  ? 0
  : trim().split(RegExp(r'\s+')).length;

  /// Wraps text into lines no longer than [lineLength], breaking on word
  /// boundaries where possible.
  ///
  /// `'The quick brown fox'.wrap(10)` -> `'The quick\nbrown fox'`
  String wrap(int lineLength) {
    if (length <= lineLength) return this;
    final words = split(RegExp(r'\s+'));
    final lines = <String>[];
    var current = StringBuffer();
 
    for (final word in words) {
      final candidateLength = current.isEmpty
          ? word.length
          : current.length + 1 + word.length;
      if (candidateLength > lineLength && current.isNotEmpty) {
        lines.add(current.toString());
        current = StringBuffer(word);
      } else {
        if (current.isNotEmpty) current.write(' ');
        current.write(word);
      }
    }
    if (current.isNotEmpty) lines.add(current.toString());
    return lines.join('\n');
  }

  bool get isValidEmail {
    var regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(this);
  }

  /// Truncates to [maxLength], appending [ellipsis] if truncation occurred.
  /// The total returned length (including the ellipsis) never exceeds
  /// [maxLength].
  ///
  /// `'Hello World'.truncate(8)` -> `'Hello...'`
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    final cut = maxLength - ellipsis.length;
    if (cut <= 0) return ellipsis.substring(0, maxLength.clamp(0, ellipsis.length));
    return substring(0, cut) + ellipsis;
  }

  /// Truncates to the last full word within [maxLength] instead of cutting
  /// mid-word.
  ///
  /// `'Hello wonderful world'.truncateWords(12)` -> `'Hello...'`
  String truncateWords(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    final limit = maxLength - ellipsis.length;
    if (limit <= 0) return truncate(maxLength, ellipsis: ellipsis);
    final slice = substring(0, limit);
    final lastSpace = slice.lastIndexOf(' ');
    final safe = lastSpace > 0 ? slice.substring(0, lastSpace) : slice;
    return safe + ellipsis;
  }


  String mask({
    int visibleStart = 0, 
    int visibleEnd = 4, 
    String maskChar = '*',
    bool unmasked = false
  }) {
    if (unmasked) return this;
    if (length <= visibleStart + visibleEnd) {
      return maskChar * length;
    }
    final start = substring(0, visibleStart);
    final end = visibleEnd == 0 ? '' : substring(length - visibleEnd);
    final maskedLength = length - visibleStart - visibleEnd;
    return start + (maskChar * maskedLength) + end;
  }

  String maskEmail({
    String maskChr = '*',
    MaskPosition position = MaskPosition.center,
    int maskedLength = 0
  }) {
    if (isBlank) return this;
    if (!isValidEmail) return this;
    final str = this;
    final strList = str.split('@');
    final prefix = strList.first;
    final suffix = strList.last;
    if (maskedLength >= prefix.length) position = MaskPosition.full;
    if (position == MaskPosition.full || prefix.length <= 2) {
      return '${maskChr * prefix.length}@$suffix';
    }
    if (maskedLength <= 0) maskedLength = (prefix.length ~/ 2);
    if (position == MaskPosition.center) {
      final unmaskedLength = prefix.length - maskedLength;
      final first = unmaskedLength ~/ 2;
      return '${prefix.substring(0, first)}${maskChr * maskedLength}${prefix.substring(first + maskedLength)}@$suffix';
    }
    if (position == MaskPosition.right) {
      return '${prefix.substring(0, prefix.length  - maskedLength)}${maskChr * maskedLength}@$suffix';
    }
    return '${maskChr * maskedLength}${prefix.substring(maskedLength)}@$suffix';
  }

  String padChar({
    int length = 0,
    String chr = ' ',
    PadPosition position = PadPosition.left
  }) {
    final input = this;
    return position == PadPosition.left
    ? input.padLeft(length, chr)
    : input.padRight(length, chr);
  }

  /// Splits an arbitrary identifier or phrase into individual words, treating
  /// spaces, underscores, hyphens, and camelCase/PascalCase boundaries all as
  /// separators. This is the shared engine behind all case-conversion methods.
  List<String> get splitIntoWords{
    final input = this;
    if (input.isEmpty) return [];
  
    // Insert a boundary before an uppercase letter that follows a
    // lowercase letter or digit: 'userID' -> 'user ID', 'fooBar' -> 'foo Bar'.
    final camelSplit = input.replaceAllMapped(
      RegExp(r'(?<=[a-z0-9])(?=[A-Z])'),
      (m) => ' ',
    );
  
    // Also split a run of uppercase letters followed by a lowercase one:
    // 'HTTPServer' -> 'HTTP Server'.
    final acronymSplit = camelSplit.replaceAllMapped(
      RegExp(r'(?<=[A-Z])(?=[A-Z][a-z])'),
      (m) => ' ',
    );
  
    final normalized = acronymSplit.replaceAll(RegExp(r'[_\-]+'), ' ');
  
    return normalized
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

}