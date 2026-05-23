import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormat = NumberFormat('#,###', 'en_NG');
  static final _dateFormat = DateFormat('d MMM, yyyy');
  static final _shortDateFormat = DateFormat('MMM d');
  static final _timeFormat = DateFormat('h:mm a');
  static final _monthYearFormat = DateFormat('MMM yyyy');

  /// Formats a number as Nigerian naira: ₦1,234,000
  static String formatCurrency(num amount) {
    return '₦${_currencyFormat.format(amount.toInt())}';
  }

  /// Alias for [formatCurrency]
  static String currency(num amount) => formatCurrency(amount);

  /// Formats a [DateTime] as "24 Oct, 2026"
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Alias for [formatDate]
  static String date(DateTime date) => formatDate(date);

  /// Formats a [DateTime] as "Oct 24"
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Alias for [formatShortDate]
  static String shortDate(DateTime date) => formatShortDate(date);

  /// Formats a [DateTime] as "h:mm AM/PM"
  static String time(DateTime t) => _timeFormat.format(t);

  /// Month + year: "Apr 2026"
  static String monthYear(DateTime date) => _monthYearFormat.format(date);

  /// Relative time: "2 mins ago", "1 hr ago", "3 days ago", "Just now"
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 2) return '1 min ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 2) return '1 hr ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    if (diff.inDays < 2) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return _shortDateFormat.format(dateTime);
  }

  /// Alias for [timeAgo]
  static String relativeTime(DateTime dateTime) => timeAgo(dateTime);

  /// Formats duration in minutes to a human-readable string: "2 hrs", "30 mins"
  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return '$hours hr${hours == 1 ? '' : 's'}';
    return '$hours hr${hours == 1 ? '' : 's'} $remaining mins';
  }

  /// Message time: shows time if today, "Yesterday" if yesterday, day name within week, short date otherwise
  static String messageTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inDays == 0) return _timeFormat.format(dateTime);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(dateTime);
    return _shortDateFormat.format(dateTime);
  }
}
