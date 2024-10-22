import 'package:flutter/material.dart';
import 'package:smart/feature/search/ui/bottom_sheets/filter_bottom_sheet_dialog.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/icon_button.dart';
import 'package:smart/widgets/textField/elevated_text_field.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    super.key,
    required this.onSubmitted,
    required this.onChange,
    required this.searchController,
    required this.searchControllerKey,
    required this.onTap,
    required this.showBackButton,
    required this.showFilter,
    required this.showCancelAction,
    required this.onCancelAction,
    required this.autofocus,
    required this.focusNode,
  });
  final Function(String) onSubmitted;
  final Function(String) onChange;
  final Function() onTap;
  final TextEditingController searchController;
  final GlobalKey<FormFieldState<String>>? searchControllerKey;
  final bool showBackButton;
  final bool showCancelAction;
  final bool showFilter;
  final bool autofocus;
  final Function onCancelAction;
  final FocusNode focusNode;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.showBackButton) const CustomBackButton(),
        Expanded(
          child: ElevatedTextField(
            searchControllerKey: widget.searchControllerKey,
            action: TextInputAction.search,
            onSubmitted: widget.onSubmitted,
            onChange: widget.onChange,
            height: 44,
            hintText: 'Recherche a Alger',
            controller: widget.searchController,
            icon: "Assets/icons/only_search.svg",
            onTap: widget.onTap,
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
          ),
        ),
        const SizedBox(width: 10),
        if (widget.showFilter)
          CustomIconButtonSearch(
            assetName: 'Assets/icons/sliders.svg',
            callback: () {
              showFilterBottomSheet(
                context: context,
                needOpenNewScreen: false,
              );
            },
            height: 44,
            width: 44,
          ),
        if (widget.showCancelAction)
          TextButton(
            onPressed: () {
              widget.onCancelAction();
            },
            child: Text(localizations.cancelation),
          ),
      ],
    );
  }
}
//
// ElevatedTextField(
// action: TextInputAction.search,
// onSubmitted: (String? a) {
// searchManager.setSearch(false);
// searchManager.saveInHistory(a!);
// setState(() {});
// BlocProvider.of<SearchAnnouncementCubit>(context)
//     .searchAnnounces(a, true);
// },
// onChange: (String a) {
// searchManager.setSearch(true);
// setState(() {});
// BlocProvider.of<SearchItemsCubit>(context).search(a);
// BlocProvider.of<PopularQueriesCubit>(context)
//     .loadPopularQueries();
// },
// width: MediaQuery.of(context).size.width - 115,
// height: 44,
// hintText: 'Recherche a Alger',
// controller: searchController,
// icon: "Assets/icons/only_search.svg",
// onTap: () {},
// ),
