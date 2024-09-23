extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    //TOD
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
