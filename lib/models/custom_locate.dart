import 'package:smart/main.dart';

class CustomLocale {
  final String name;
  final String shortName;

  CustomLocale({
    required this.name,
    required this.shortName,
  });

  String get displayName {
    if (currentLocaleShortName.value == 'ar') {
      switch (shortName) {
        case 'fr':
          return 'الفرنسية';
        case 'ar':
          return 'العربية';
      }
    } else {
      switch (shortName) {
        case 'fr':
          return 'Français';
        case 'ar':
          return 'Arabe';
      }
    }
    return shortName;
  }

  CustomLocale.fr()
      : name = 'Français',
        shortName = 'fr';

  CustomLocale.ar()
      : name = 'Arabe',
        shortName = 'ar';
}
