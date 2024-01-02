
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/sort_types.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/dropDownSingleCheckBox/custom_dropdown_single_checkbox.dart';
import 'package:smart/widgets/textField/price_widget.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key, this.needOpenNewScreen = false});

  final bool needOpenNewScreen;

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    final TextEditingController minPriceController =
    TextEditingController(text: searchCubit.minPrice.toString());
    final TextEditingController maxPriceController =
    TextEditingController(text: searchCubit.maxPrice.toString());

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                width: 120,
                height: 4,
                decoration: ShapeDecoration(
                    color: const Color(0xFFDDE1E7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtres',
                    style: AppTypography.font20black,
                  ),
                  InkWell(
                    onTap: () {
                      searchCubit.clearFilters();
                      setState(() {});
                    },
                    child: Text(
                      'Réinitialiser tout',
                      style: AppTypography.font12black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            PriceWidget(
              minPriseController: minPriceController,
              maxPriseController: maxPriceController,
            ),
            CustomDropDownSingleCheckBox(
                parameters: Parameter(
                    variants: SortTypes.toFrList(),
                    key: 'Triage',
                    current: SortTypes.frTranslates[searchCubit.sortBy]!),
                onChange: (a) {
                  searchCubit.sortType = SortTypes.codeFromFr(a ?? '');
                  setState(() {});
                },
                currentVariable: SortTypes.frTranslates[searchCubit.sortBy]!),
            CustomTextButton.orangeContinue(
                callback: () {
                  RepositoryProvider.of<SearchManager>(context)
                      .setSearch(false);
                  searchCubit.minPrice = double.parse(minPriceController.text);
                  searchCubit.maxPrice = double.parse(maxPriceController.text);
                  searchCubit.setFilters();
                  Navigator.pop(context);
                  if (widget.needOpenNewScreen) {
                    Navigator.pushNamed(context, AppRoutesNames.search);
                  }

                  setState(() {});
                },
                text: 'Appliquer',
                active: true)
          ],
        ),
      ),
    );
  }
}
