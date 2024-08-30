import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  return NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(amount);
}
