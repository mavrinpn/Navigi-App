import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/search/bloc/search_announcement_cubit.dart';
import 'package:smart/feature/search/bloc/select_subcategory/search_select_subcategory_cubit.dart';
import 'package:smart/feature/search/bloc/update_appbar_filter/update_appbar_filter_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';
import 'package:smart/managers/search_manager.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/textField/price_widget.dart';

class PriceFilterBottomSheet extends StatefulWidget {
  const PriceFilterBottomSheet({
    super.key,
    this.needOpenNewScreen = false,
  });

  final bool needOpenNewScreen;

  @override
  State<PriceFilterBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<PriceFilterBottomSheet> {
  String locale() => MyApp.getLocale(context) ?? 'fr';

  late final List<PriceType> _availableTypes;
  late PriceType _priceType;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();

    final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);

    _availableTypes = PriceTypeExtendion.availableTypesFor(selectCategoryCubit.subcategoryId ?? '');
    if (_availableTypes.contains(searchCubit.priceType)) {
      _priceType = searchCubit.priceType;
    } else {
      _priceType = _availableTypes.first;
    }

    _minPriceController = TextEditingController(text: _priceType.convertDzdToCurrencyString(searchCubit.minPrice));
    _maxPriceController = TextEditingController(text: _priceType.convertDzdToCurrencyString(searchCubit.maxPrice));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    final searchCubit = BlocProvider.of<SearchAnnouncementCubit>(context);
    final selectCategoryCubit = BlocProvider.of<SearchSelectSubcategoryCubit>(context);
    final updateAppBarFilterCubit = context.read<UpdateAppBarFilterCubit>();

    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.8,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: ShapeDecoration(
                        color: const Color(0xFFDDE1E7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
                  ),
                ),
                const SizedBox(height: 16),
                PriceWidget(
                  minPriceController: _minPriceController,
                  maxPriceController: _maxPriceController,
                  priceType: _priceType,
                  subcategoryId: selectCategoryCubit.subcategoryId ?? '',
                  onChangePriceType: (priceType) {
                    setState(() {
                      _priceType = priceType;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextButton.orangeContinue(
                  callback: () {
                    RepositoryProvider.of<SearchManager>(context).setSearch(false);

                    searchCubit.priceType = _priceType;
                    searchCubit.minPrice = _priceType.fromPriceString(_minPriceController.text);
                    searchCubit.maxPrice = _priceType.fromPriceString(_maxPriceController.text);

                    searchCubit.setFilters(
                      parameters: selectCategoryCubit.parameters,
                    );
                    Navigator.pop(context);

                    if (widget.needOpenNewScreen) {
                      Navigator.pushNamed(
                        context,
                        AppRoutesNames.search,
                        arguments: {
                          'showSearchHelper': false,
                        },
                      );
                    }
                    updateAppBarFilterCubit.needUpdateAppBarFilters();

                    setState(() {});
                  },
                  text: localizations.apply,
                  active: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
