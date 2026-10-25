import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date, String languageCode) {
    final locale = languageCode == 'ru' ? 'ru_RU' : 'en_US';
    return DateFormat('d MMMM yyyy', locale).format(date);
  }

  static String formatTime(DateTime date, String languageCode) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date, String languageCode) {
    final locale = languageCode == 'ru' ? 'ru_RU' : 'en_US';
    return DateFormat('d MMMM yyyy, HH:mm', locale).format(date);
  }

  static String getRelativeDate(DateTime date, String languageCode) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return languageCode == 'ru' ? 'Сегодня' : 'Today';
    } else if (dateOnly == yesterday) {
      return languageCode == 'ru' ? 'Вчера' : 'Yesterday';
    } else if (dateOnly == tomorrow) {
      return languageCode == 'ru' ? 'Завтра' : 'Tomorrow';
    } else {
      return formatDate(date, languageCode);
    }
  }
}
