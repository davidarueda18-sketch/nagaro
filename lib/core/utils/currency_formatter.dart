import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static String format(double amount, {String locale = 'es_CO', String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount) {
    final formatter = NumberFormat.compactCurrency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }
}
