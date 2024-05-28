import 'package:smart/main.dart';
import 'package:smart/utils/constants.dart';

enum PriceType { dzd, mln, mlrd }

extension PriceTypeExtendion on PriceType {
  static List<PriceType> availableTypesFor(String subCategoryId) {
    if ([
      immo1SubcategoryId,
      immo2SubcategoryId,
      immo3SubcategoryId,
      immo4SubcategoryId,
      immo5SubcategoryId,
      immo6SubcategoryId,
      immo7SubcategoryId,
      immo8SubcategoryId,
    ].contains(subCategoryId)) {
      return [PriceType.mln, PriceType.mlrd];
    }
    if ([carSubcategoryId].contains(subCategoryId)) {
      return [PriceType.mln, PriceType.mlrd];
    }
    return [PriceType.dzd, PriceType.mln, PriceType.mlrd];
  }

  static PriceType fromString(String? string) {
    if (string != null) {
      switch (string) {
        case 'dzd':
          return PriceType.dzd;
        case 'mln':
          return PriceType.mln;
        case 'mlrd':
          return PriceType.mlrd;
        default:
          return PriceType.dzd;
      }
    }

    return PriceType.dzd;
  }

  double _multiplier() {
    switch (this) {
      case PriceType.dzd:
        return 1;
      case PriceType.mln:
        return 10000;
      case PriceType.mlrd:
        return 10000000;
      default:
        return 1;
    }
  }

  double? fromPriceString(String text) {
    return double.tryParse(text) != null ? (double.parse(text) * _multiplier()) : null;
  }

  double convertDzdToCurrency(double value) {
    return value / _multiplier();
  }

  String convertDzdToCurrencyString(double? value) {
    if (value != null) {
      return '${value / _multiplier()}';
    }
    return '';
  }

  String convertCurrencyToCurrencyString(double? value) {
    if (value != null) {
      if (this == PriceType.mlrd) {
        if (currentLocaleShortName.value == 'ar') {
          return 'مليار $value';
        } else {
          return '$value MLRD';
        }
      } else if (this == PriceType.mln) {
        if (currentLocaleShortName.value == 'ar') {
          return 'مليون ${value.round()}';
        } else {
          return '${value.round()} MLN';
        }
      } else {
        if (currentLocaleShortName.value == 'ar') {
          return 'دينار جزائري ${value.round()}';
        } else {
          return '${value.round()} DZD';
        }
      }
    }

    return '';
  }
}
