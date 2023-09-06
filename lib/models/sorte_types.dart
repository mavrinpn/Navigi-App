class SortTypes {
  static const String priceASC = 'priceASC';
  static const String priceDESC = 'priceDESC';
  static const String dateASC = 'dateASC';
  static const String dateDESC = 'dateDESC';

  static List<String> toList() => [dateDESC, dateASC, priceDESC, priceASC];
}