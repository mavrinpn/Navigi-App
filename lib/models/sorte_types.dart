import 'package:appwrite/appwrite.dart';

class SortTypes {
  static const String priceASC = 'priceASC';
  static const String priceDESC = 'priceDESC';
  static const String dateASC = 'dateASC';
  static const String dateDESC = 'dateDESC';

  static List<String> toList() => [dateDESC, priceDESC, priceASC];

  static List<String> toFrList() => [frTranslates[dateDESC]!, frTranslates[priceDESC]!, frTranslates[priceASC]!];

  static String? toQuery(String name) {
    if (name == priceASC) return Query.orderAsc('price');
    if (name == priceDESC) return Query.orderDesc('price');
    if (name == dateASC) return Query.orderAsc('\$createdAt');
    if (name == dateDESC) return Query.orderDesc('\$createdAt');
    return null;
  }

  static Map<String, String> frTranslates = {
    dateDESC: 'Par date',
    //dateASC: '',
    priceASC: 'D\'abord pas cher',
    priceDESC: 'D\'abord cher'
  };

  static String codeFromFr(String setting) {
    String? result;
    frTranslates.forEach((key, value) {if (value == setting) result = key;});
    return result ?? dateDESC;
  }
}