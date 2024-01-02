import 'package:flutter/material.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/widgets/button/icon_button.dart';
import 'package:smart/widgets/textField/elevated_text_field.dart';

import 'filters_bottom_sheet.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key, required this.onSubmitted, required this.onChange, required this.searchController});
  final Function(String?) onSubmitted;
  final Function(String?) onChange;
  final TextEditingController searchController;


  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.black,
            ),
          ),
          ElevatedTextField(
            action: TextInputAction.search,
            onSubmitted: widget.onSubmitted,
            onChange: widget.onChange,
            width: MediaQuery.of(context).size.width - 115,
            height: 44,
            hintText: 'Recherche a Alger',
            controller: widget.searchController,
            icon: "Assets/icons/only_search.svg",
            onTap: () {},
          ),
          const Spacer(),
          CustomIconButtonSearch(
              assetName: 'Assets/icons/sliders.svg',
              callback: () {
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
                    return const FiltersBottomSheet();
                  },
                );
              },
              height: 44,
              width: 44)
        ],
      ),
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
