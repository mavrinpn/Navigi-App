import 'package:email_validator/email_validator.dart';
import 'package:smart/localization/app_localizations.dart';

String? emailValidator({
  required String? value,
  required AppLocalizations localizations,
}) {
  if (value == null || value.isEmpty) {
    return localizations.errorReviewOrEnterOther;
  }
  if (!EmailValidator.validate(value)) {
    return localizations.enterValidEmail;
  }
  return null;
}

String? passwordValidator({
  required String? value,
  required String otherValue,
  required AppLocalizations localizations,
}) {
  RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)$');

  if (value == null || value.isEmpty) {
    return localizations.errorReviewOrEnterOther;
  }
  if (value != otherValue) {
    return localizations.errorReviewOrEnterOther;
  }
  if (value.length < 8) {
    return localizations.errorReviewOrEnterOther;
  }
  if (!regex.hasMatch(value) || !regex.hasMatch(otherValue)) {
    return localizations.passwordMustContains;
  }

  return null;
}
