enum PriceType { dzd, mln, mlrd }

extension PriceTypeExtendion on PriceType {
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
    return double.tryParse(text) != null
        ? (double.parse(text) * _multiplier())
        : null;
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
      if (this != PriceType.mlrd) {
        return '${value.round()} ${name.toUpperCase()}';
      } else {
        return '$value ${name.toUpperCase()}';
      }
    }
    return '';
  }
}
