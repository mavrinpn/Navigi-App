import 'package:intl/intl.dart';
import 'package:smart/models/messenger/chat_item.dart';

class DateSplitter implements ChatItem {
  final DateTime _date;

  DateSplitter({required DateTime dateTime})
      : _date = dateTime;

  //String get date => '${_date.day}.${_date.month}.${_date.year}';
  String get date => DateFormat(DateFormat.YEAR_MONTH_DAY).format(_date);
}
