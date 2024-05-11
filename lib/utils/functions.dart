import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/main.dart';
import 'package:uuid/uuid.dart';

final maskPhoneFormatter = MaskTextInputFormatter(
  mask: '+213 (###) ## ## ##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

int _calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}

String dateTimeToString(DateTime dt) {
  final isToday = _calculateDifference(dt) == 0;

  if (isToday) {
    if (currentLocaleShortName.value == 'fr') {
      return 'Aujourd\'Hui ${DateFormat('HH:mm').format(dt)}';
    } else {
      return 'اليوم ${DateFormat('HH:mm').format(dt)}';
    }
  } else {
    return '${DateFormat('MMM d').format(dt)} ${DateFormat('HH:mm').format(dt)}';
  }
}

String convertPhoneToTempEmail(String phone) {
  const id = Uuid();

  return '89$phone@${id.v1()}.ru';
// return '$phone@gmail.com';
}

String convertPhoneToVerifiedEmail(String phone) {
  return '89$phone@appwriteverificated.navigi';
}
