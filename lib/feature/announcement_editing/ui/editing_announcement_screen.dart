import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/change_category_button.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/description.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/parameters.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/price_section.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/title.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/create_announcement/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/data/models/car_filter.dart';
import 'package:smart/feature/create_announcement/data/models/marks_filter.dart';
import 'package:smart/feature/create_announcement/ui/widgets/add_image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_location_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/managers/places_manager.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/item/subcategory_filters.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';

class EditingAnnouncementScreen extends StatefulWidget {
  const EditingAnnouncementScreen({super.key});

  @override
  State<EditingAnnouncementScreen> createState() => _EditingAnnouncementScreenState();
}

List<CustomLocate> listLocates = [
  CustomLocate.fr(),
  CustomLocate.ar(),
];

class _EditingAnnouncementScreenState extends State<EditingAnnouncementScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  PriceType _priceType = PriceType.dzd;
  String _place = '';
  bool _areaSelected = true;
  List<Parameter> _parameters = [];
  String? _newSubcategoryId;
  CarFilter? _newCarFilter;
  MarksFilter? _newMarksFilter;
  SubcategoryFilters? _newSubcategoryFilters;

  @override
  void initState() {
    super.initState();
    initialTextFields();

    BlocProvider.of<PlacesCubit>(context).searchCities('');

    final announcementEditCubit = BlocProvider.of<AnnouncementEditCubit>(context);
    setParameretres(
      announcementEditCubit.data?.subcollectionId ?? '',
      announcementEditCubit.data?.modelId ?? '',
    );
    final subcategoryId = announcementEditCubit.data?.subcollectionId ?? '';
    final creatingManager = context.read<CreatingAnnouncementManager>();

    if (realEstateSubcategories.contains(subcategoryId) || servicesSubcategories.contains(subcategoryId)) {
      creatingManager.specialOptions.add(SpecialAnnouncementOptions.customPlace);
    }
  }

  void setParameretres(
    String subcategory,
    String modelId,
  ) {
    context
        .read<ItemSearchCubit>()
        .getSubcategoryAndModelParameters(
          subcategory: subcategory,
          modelId: modelId,
        )
        .then((result) {
      _parameters = result.$1;
      _newSubcategoryFilters = result.$2;
      setState(() {});
    });
  }

  CustomLocate? customLocate;
  bool buttonActive = true;

  String? priceValidator(String? value) {
    final localizations = AppLocalizations.of(context)!;
    final announcementEditCubit = BlocProvider.of<AnnouncementEditCubit>(context);
    double? n;
    n = double.tryParse(priceController.text) ?? -1;
    if (n < 0) {
      buttonActive = false;
      return localizations.errorReviewOrEnterOther;
    }
    buttonActive = buttonActive && announcementEditCubit.images.isNotEmpty;
    return null;
  }

  void savePrice() {
    setState(() {
      priceController.text = double.parse(priceController.text).toString();
    });
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      log("can't unfocus");
    }
  }

  void updateTextSelection() {
    descriptionController.selection =
        TextSelection.fromPosition(TextPosition(offset: descriptionController.text.length));
    titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
  }

  void validateButtonActive() {
    buttonActive = titleController.text.isNotEmpty;
    buttonActive = buttonActive && descriptionController.text.isNotEmpty;
    buttonActive = _areaSelected;

    priceValidator(priceController.text);
  }

  void initialTextFields() {
    final cubit = RepositoryProvider.of<AnnouncementEditCubit>(context);
    titleController.text = cubit.data?.title ?? '';
    descriptionController.text = cubit.data?.description ?? '';
    _priceType = cubit.data?.priceType ?? PriceType.dzd;
    priceController.text = _priceType.convertDzdToCurrencyString(cubit.data?.price ?? 0);
    _place = cubit.data?.area.name ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateTextSelection();
    final placeManager = RepositoryProvider.of<PlacesManager>(context);
    final announcementEditCubit = context.read<AnnouncementEditCubit>();
    final localizations = AppLocalizations.of(context)!;
    return PopScope(
        canPop: true,
        onPopInvoked: (v) {
          announcementEditCubit.closeEdit();
        },
        child: BlocConsumer<AnnouncementEditCubit, AnnouncementEditState>(
          listener: (context, state) {
            try {
              if (state is AnnouncementEditLoading) {
                Dialogs.showModal(context, AppAnimations.circleFadingAnimation);
              } else {
                Dialogs.hide(context);
              }
            } catch (e) {
              log('Dialogs error');
            }

            if (state is AnnouncementEditSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.changesSaved)));
              BlocProvider.of<CreatorCubit>(context).setUserId(RepositoryProvider.of<AuthRepository>(context).userId);
              Navigator.of(context).pop();
            } else if (state is AnnouncementEditFail) {
              CustomSnackBar.showSnackBar(context, state.error, 10);
              // ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text(localizations.dataSavingError)));
            }
          },
          builder: (context, state) {
            validateButtonActive();

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.appBarColor,
                elevation: 0,
                titleSpacing: 6,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(callback: () {
                      announcementEditCubit.closeEdit();
                    }),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            localizations.edit,
                            style: AppTypography.font20black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomScrollView(
                    slivers: [
                      // SliverToBoxAdapter(
                      //   child: Align(
                      //     alignment: Alignment.topRight,
                      //     child: InkWell(
                      //       borderRadius: BorderRadius.circular(10),
                      //       onTap: () {
                      //         for (var param in _parameters) {
                      //           if (param is SelectParameter) {
                      //             param.currentValue = param.variants[0];
                      //           } else if (param is SingleSelectParameter) {
                      //             param.currentValue = param.variants[0];
                      //           } else if (param is MultiSelectParameter) {
                      //             param.selectedVariants = [];
                      //           } else if (param is InputParameter) {
                      //             param.value = null;
                      //           } else if (param is TextParameter) {
                      //             param.value = '';
                      //           }
                      //         }
                      //         setState(() {});
                      //       },
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(4),
                      //         child: Text(
                      //           localizations.resetEverything,
                      //           style: AppTypography.font12gray,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ChangeCategoryButton(
                        onTap: () async {
                          final creatingManager = context.read<CreatingAnnouncementManager>();
                          creatingManager.isCreating = false;
                          await Navigator.pushNamed(context, AppRoutesNames.announcementCreatingCategory);
                          final subcategoryId = creatingManager.creatingData.subcategoryId ?? '';
                          final carModelId = creatingManager.carFilter?.modelId;
                          final markModelId = creatingManager.marksFilter?.modelId;
                          setParameretres(subcategoryId, carModelId ?? markModelId ?? '');
                          _newSubcategoryId = subcategoryId;
                          _newCarFilter = creatingManager.carFilter;
                          _newMarksFilter = creatingManager.marksFilter;
                        },
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 10)),
                      PriceSection(
                        onChange: (String value) {
                          final price = _priceType.fromPriceString(value);
                          announcementEditCubit.onPriceChanged(price);
                        },
                        priceType: _priceType,
                        subCategoryId: announcementEditCubit.data?.subcollectionId ?? '',
                        onChangePriceType: (priceType) {
                          setState(() {
                            _priceType = priceType;
                          });
                          final price = _priceType.fromPriceString(priceController.text);
                          announcementEditCubit.onPriceChanged(price);
                          announcementEditCubit.onPriceTypeChanged(priceType);
                        },
                        priceController: priceController,
                        priceValidator: priceValidator,
                        localizations: localizations,
                        savePrice: savePrice,
                      ),
                      TitleSection(
                        titleController: titleController,
                        onChange: (v) {
                          if ((v ?? '').isEmpty) {
                            setState(() {
                              buttonActive = false;
                            });
                          } else {
                            announcementEditCubit.onTitleChange(v);
                          }
                        },
                        localizations: localizations,
                      ),
                      DescriptionSection(
                          localizations: localizations,
                          descriptionController: descriptionController,
                          onChange: (v) {
                            if ((v ?? '').isEmpty) {
                              setState(() {
                                buttonActive = false;
                              });
                            } else {
                              announcementEditCubit.onDescriptionChanged(v);
                            }
                          }),
                      const SliverToBoxAdapter(child: SizedBox(height: 26)),
                      SliverToBoxAdapter(child: Text(localizations.location, style: AppTypography.font18black)),
                      const SliverToBoxAdapter(child: SizedBox(height: 26)),
                      SliverToBoxAdapter(
                        child: SelectLocationWidget(
                          cityDistrict: announcementEditCubit.data?.area,
                          longitude: announcementEditCubit.data?.longitude,
                          latitude: announcementEditCubit.data?.latitude,
                          onSetActive: (active) {
                            setState(() {
                              _areaSelected = active;
                            });
                          },
                          onChangePlace: (place) {
                            _place = place;
                          },
                        ),
                      ),
                      ParametersSection(
                        paramaters: _parameters,
                        staticParameters: announcementEditCubit.data?.staticParameters,
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 26)),
                      SliverToBoxAdapter(child: Text(localizations.photo, style: AppTypography.font18black)),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 26),
                      ),
                      buildImagesSection(),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 32),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextButton.orangeContinue(
                            active: buttonActive,
                            callback: () {
                              if (buttonActive) {
                                final creatingManager = context.read<CreatingAnnouncementManager>();
                                final place = placeManager.searchPlaceIdByName(_place);
                                announcementEditCubit.onPlaceChange(place);
                                announcementEditCubit.onCustomCoordinateChange(creatingManager.customPosition);
                                announcementEditCubit.onParametersChanged(
                                  newParamaters: _parameters,
                                  newCarFilter: _newCarFilter,
                                  newMarksFilter: _newMarksFilter,
                                  newSubcategoryFilters: _newSubcategoryFilters,
                                );

                                final newCarMarkId = _newCarFilter?.markId;
                                final newCarModelId = _newCarFilter?.modelId;
                                final newMarkMarkId = _newMarksFilter?.markId;
                                final newMarkModelId = _newMarksFilter?.modelId;

                                announcementEditCubit.saveChanges(
                                  _newSubcategoryId,
                                  newCarMarkId ?? newMarkMarkId,
                                  newCarModelId ?? newMarkModelId,
                                );
                              }
                            },
                            text: localizations.save),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildImagesSection() {
    final cubit = context.read<AnnouncementEditCubit>();
    final localizations = AppLocalizations.of(context)!;
    return cubit.images.isEmpty
        ? SliverToBoxAdapter(
            child: CustomTextButton.withIcon(
              active: true,
              activeColor: AppColors.dark,
              callback: cubit.pickImages,
              text: localizations.addPictures,
              styleText: AppTypography.font14white,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          )
        : SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: cubit.images.length + 1,
              (_, int index) {
                final images = cubit.images;
                if (index != images.length) {
                  return ImageWidget(
                    bytes: images[index].bytes,
                    callback: () {
                      cubit.deleteImage(images[index]);
                    },
                  );
                } else {
                  return AddImageWidget(
                    callback: cubit.pickImages,
                  );
                }
              },
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 106,
              childAspectRatio: 0.938,
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              crossAxisCount: 3,
            ),
          );
  }
}
