import 'package:appwrite/appwrite.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';
import 'package:smart/services/parameters_parser.dart';

class SortTypes {
  static const String priceASC = 'priceASC';
  static const String priceDESC = 'priceDESC';
  static const String dateASC = 'dateASC';
  static const String dateDESC = 'dateDESC';

  static List<String> toList() => [dateDESC, priceDESC, priceASC];

  static List<String> toFrList() => [
        frTranslates[dateDESC]!,
        frTranslates[priceDESC]!,
        frTranslates[priceASC]!
      ];

  static String? toQuery(String name) {
    if (name == priceASC) return Query.orderAsc('price');
    if (name == priceDESC) return Query.orderDesc('price');
    if (name == dateASC) return Query.orderAsc('\$createdAt');
    if (name == dateDESC) return Query.orderDesc('\$createdAt');
    return null;
  }

  static Map<String, String> frTranslates = {
    dateDESC: 'Par date',
    priceASC: 'D\'abord pas cher',
    priceDESC: 'D\'abord cher'
  };

  static Map<String, String> arTranslates = {
    dateDESC: 'حسب التاريخ',
    priceASC: 'أول رخيصة',
    priceDESC: 'أول مكلفة'
  };

  static String codeFromFr(String setting) {
    String? result;
    frTranslates.forEach((key, value) {
      if (value == setting) result = key;
    });
    return result ?? dateDESC;
  }

  static SelectParameter sortTypesParameter() {
    final options = [
      ParameterOption(SortTypes.dateDESC,
          nameAr: SortTypes.arTranslates[SortTypes.dateDESC]!,
          nameFr: SortTypes.frTranslates[SortTypes.dateDESC]!),
      ParameterOption(SortTypes.priceASC,
          nameAr: SortTypes.arTranslates[SortTypes.priceASC]!,
          nameFr: SortTypes.frTranslates[SortTypes.priceASC]!),
      ParameterOption(SortTypes.priceDESC,
          nameAr: SortTypes.arTranslates[SortTypes.priceDESC]!,
          nameFr: SortTypes.frTranslates[SortTypes.priceDESC]!),
    ];

    return SelectParameter(
        key: 'sortType', variants: options, arName: 'فرز', frName: 'Triage');
  }
}
