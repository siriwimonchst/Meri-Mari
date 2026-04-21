import 'package:intl/intl.dart';

/// Centralized utility for formatting prices and numbers in the Meri-Mari app.
class PriceFormatter {
  /// Formats a double into a string with thousand separators (e.g., 3,999).
  /// Standardizes the format across the entire application.
  static String format(double price) {
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(price);
  }

  /// Returns a formatted price string prefixed with the currency symbol.
  static String formatWithCurrency(double price, {String symbol = '฿'}) {
    return '$symbol${format(price)}';
  }
}
