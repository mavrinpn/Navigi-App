import 'package:uuid/uuid.dart';

String dateTimeToString(DateTime dt) {
  String hour = '${dt.hour}';
  String minute = '${dt.minute}';

  if (hour.length == 1) hour = '0$hour';
  if (minute.length == 1) minute = '0$minute';
  final DateTime n = DateTime.now();
  String date = dt.month == n.month && dt.day == n.day && dt.year == n.year
      ? 'Сегодня'
      : '${dt.day}.${dt.month}.${dt.day}';

  return '$date $hour:$minute';
}

String convertPhoneToTempEmail(String phone) {
  const id = Uuid();

  return '89$phone@${id.v1()}.ru';
// return '$phone@gmail.com';
}

String convertPhoneToVerifiedEmail(String phone) {
  return '89$phone@appwriteverificated.navigi';
}
