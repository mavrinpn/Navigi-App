class SortTypes {
  static const String priceASC = 'priceASC';
  static const String priceDESC = 'priceDESC';
  static const String dateASC = 'dateASC';
  static const String dateDESC = 'dateDESC';

  static List<String> toList() => [dateDESC, priceDESC, priceASC];

  static List<String> toFrList() => [frTranslates[dateDESC]!, frTranslates[priceDESC]!, frTranslates[priceASC]!];

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