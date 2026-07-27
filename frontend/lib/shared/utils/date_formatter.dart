import 'package:intl/intl.dart';

class DateFormatter {
  static String display(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  static String api(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String today() {
    return api(DateTime.now());
  }
}