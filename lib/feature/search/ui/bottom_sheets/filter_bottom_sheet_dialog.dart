import 'package:flutter/material.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/feature/search/ui/bottom_sheets/common_filters_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/location_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/price_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/single_filter_bottom_sheet.dart';

void showFilterBottomSheet({
  required BuildContext context,
  String? parameterKey,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      if (parameterKey == FilterKeys.price) {
        return const PriceFilterBottomSheet();
      } else if (parameterKey == FilterKeys.location) {
        return const LocationFilterBottomSheet();
      } else if (parameterKey != null) {
        return SingleFilterBottomSheet(parameterKey: parameterKey);
      } else {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const CommonFiltersBottomSheet(),
        );
      }
    },
  );
}
