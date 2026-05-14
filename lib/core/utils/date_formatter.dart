import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String formatShort(DateTime date) =>
      DateFormat('dd/MM/yyyy', 'es').format(date);

  static String formatLong(DateTime date) =>
      DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);

  static String formatMonthYear(DateTime date) =>
      DateFormat('MMMM yyyy', 'es').format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    return formatShort(date);
  }
}
