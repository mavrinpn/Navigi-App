import 'package:flutter/material.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_keys.dart';
import 'package:smart/feature/search/ui/bottom_sheets/common_filters_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/location_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/price_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/single_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/bottom_sheets/subcategory_filter_bottom_sheet.dart';
import 'package:smart/feature/search/ui/search_screen.dart';

Future<bool?> showFilterBottomSheet({
  required BuildContext context,
  required bool needOpenNewScreen,
  String? parameterKey,
}) {
  return showModalBottomSheet<bool?>(
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
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
          child: const PriceFilterBottomSheet(),
        );
      } else if (parameterKey == FilterKeys.location) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
          child: const LocationFilterBottomSheet(),
        );
      } else if (parameterKey == FilterKeys.subcategory) {
        final searchText = searchScreenTextController.text;

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
            child: SubcategoriesWidget(
              isBottomSheet: true,
              searchText: searchText,
            ),
          ),
        );
      } else if (parameterKey != null) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
          child: SingleFilterBottomSheet(parameterKey: parameterKey),
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
          child: CommonFiltersBottomSheet(needOpenNewScreen: needOpenNewScreen),
        );
      }
    },
  );
}
