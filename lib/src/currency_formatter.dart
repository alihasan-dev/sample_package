class CurrencyFormatter {
  /// Format with currency symbol and comma separator
  /// Example: ₹ 12,345.67
  static String format(
    double amount, {
    String symbol = '₹',
    int decimalPlaces = 2,
    bool showSymbol = true,
  }) {
    final isNegative = amount < 0;
    final absoluteAmount = amount.abs();

    final fixed = absoluteAmount.toStringAsFixed(decimalPlaces);
    final parts = fixed.split('.');

    final integerPart = _addCommas(parts[0]);
    final decimalPart =
        decimalPlaces > 0 ? '.${parts[1]}' : '';

    final formatted =
        "${showSymbol ? '$symbol ' : ''}$integerPart$decimalPart";

    return isNegative ? "-$formatted" : formatted;
  }

  /// Format without currency symbol
  static String formatNumber(
    double amount, {
    int decimalPlaces = 2,
  }) {
    return format(
      amount,
      showSymbol: false,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Compact format
  /// 1200 -> 1.2K
  /// 1500000 -> 1.5M
  static String compact(
    double amount, {
    int decimalPlaces = 1,
  }) {
    final absAmount = amount.abs();
    final isNegative = amount < 0;

    String result;

    if (absAmount >= 1e9) {
      result = "${(absAmount / 1e9).toStringAsFixed(decimalPlaces)}B";
    } else if (absAmount >= 1e6) {
      result = "${(absAmount / 1e6).toStringAsFixed(decimalPlaces)}M";
    } else if (absAmount >= 1e3) {
      result = "${(absAmount / 1e3).toStringAsFixed(decimalPlaces)}K";
    } else {
      result = absAmount.toStringAsFixed(decimalPlaces);
    }

    return isNegative ? "-$result" : result;
  }

  /// Format in Indian numbering system
  /// 12345678 -> 1,23,45,678
  static String formatIndian(double amount,
      {int decimalPlaces = 2, String symbol = '₹'}) {
    final isNegative = amount < 0;
    final absoluteAmount = amount.abs();

    final fixed = absoluteAmount.toStringAsFixed(decimalPlaces);
    final parts = fixed.split('.');

    String integerPart = parts[0];
    String lastThree = integerPart.substring(
        integerPart.length - 3 < 0 ? 0 : integerPart.length - 3);

    String remaining = integerPart.length > 3
        ? integerPart.substring(0, integerPart.length - 3)
        : '';

    final buffer = StringBuffer();

    if (remaining.isNotEmpty) {
      buffer.write(_addIndianCommas(remaining));
      buffer.write(',');
    }

    buffer.write(lastThree);

    final decimalPart =
        decimalPlaces > 0 ? '.${parts[1]}' : '';

    final formatted = "$symbol ${buffer.toString()}$decimalPart";

    return isNegative ? "-$formatted" : formatted;
  }

  // -------------------------
  // Private helper methods
  // -------------------------

  static String _addCommas(String number) {
    final buffer = StringBuffer();
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      buffer.write(number[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }

    return buffer.toString().split('').reversed.join();
  }

  static String _addIndianCommas(String number) {
    final buffer = StringBuffer();
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      buffer.write(number[i]);
      count++;
      if (count % 2 == 0 && i != 0) {
        buffer.write(',');
      }
    }

    return buffer.toString().split('').reversed.join();
  }
}
