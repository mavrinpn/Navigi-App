import 'package:flutter/material.dart';
import 'package:smart/widgets/button/icon_button.dart';
import 'package:smart/widgets/textField/elevated_text_field.dart';

import '../../../../localization/app_localizations.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key, required this.openSearchScreen, required this.isSearch, required this.openFilters, required this.cancel});
  final VoidCallback openSearchScreen;
  final bool isSearch;
  final VoidCallback openFilters;
  final VoidCallback cancel;
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedTextField(
            readOnly: true,
            onTap: openSearchScreen,
            width: isSearch
                ? MediaQuery.of(context).size.width - 120
                : MediaQuery.of(context).size.width - 91,
            height: 44,
            hintText: localizations.researchInAlgiers,
            icon: "Assets/icons/only_search.svg",
          ),
          const SizedBox(width: 16),
          CustomIconButtonSearch(
              assetName: 'Assets/icons/sliders.svg',
              callback: openFilters,
              height: 44,
              width: 44),
          isSearch
              ? TextButton(
            onPressed: cancel,
            child: Text(localizations.cancelation),
          )
              : Container(),
        ],
      ),
    );
  }
}