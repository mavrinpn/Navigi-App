import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/description.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/parameters.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/price_section.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/title.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/feature/create_announcement/bloc/places_search/places_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/add_image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_location_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/managers/creating_announcement_manager.dart';
import 'package:smart/managers/places_manager.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';

class EditingAnnouncementScreen extends StatefulWidget {
  const EditingAnnouncementScreen({super.key});

  @override
  State<EditingAnnouncementScreen> createState() =>
      _EditingAnnouncementScreenState();
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

  @override
  void initState() {
    super.initState();
    initialTextFields();

    BlocProvider.of<PlacesCubit>(context).searchCities('');
    final creatingManager =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);
    if ([servicesCategoryId, realEstateCategoryId]
        .contains(creatingManager.creatingData.categoryId)) {
      creatingManager.specialOptions
          .add(SpecialAnnouncementOptions.customPlace);
    }
  }

  CustomLocate? customLocate;
  bool buttonActive = true;

  String? priceValidator(String? value) {
    final localizations = AppLocalizations.of(context)!;
    final announcementEditCubit =
        BlocProvider.of<AnnouncementEditCubit>(context);
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
    descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: descriptionController.text.length));
    titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: titleController.text.length));
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
    priceController.text =
        _priceType.convertDzdToCurrencyString(cubit.data?.price ?? 0);
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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.changesSaved)));
              BlocProvider.of<CreatorCubit>(context).setUserId(
                  RepositoryProvider.of<AuthRepository>(context).userId);
              Navigator.of(context).pop();
            } else if (state is AnnouncementEditFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.dataSavingError)));
            }
          },
          builder: (context, state) {
            validateButtonActive();

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.empty,
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
                      PriceSection(
                        onChange: (String value) {
                          final price = _priceType.fromPriceString(value);
                          announcementEditCubit.onPriceChanged(price);
                        },
                        priceType: _priceType,
                        subCategoryId:
                            announcementEditCubit.data?.subcollectionId ?? '',
                        onChangePriceType: (priceType) {
                          setState(() {
                            _priceType = priceType;
                          });
                          final price =
                              _priceType.fromPriceString(priceController.text);
                          announcementEditCubit.onPriceChanged(price);
                          announcementEditCubit.onPriceTypeChanged(priceType);
                        },
                        priceController: priceController,
                        priceValidator: priceValidator,
                        localizations: localizations,
                        savePrice: savePrice,
                      ),
                      ParametersSection(cubit: announcementEditCubit),
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
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 26),
                      ),
                      SliverToBoxAdapter(
                          child: Text(localizations.location,
                              style: AppTypography.font18black)),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 26),
                      ),
                      SliverToBoxAdapter(
                        child: SelectLocationWidget(
                          cityDistrict: announcementEditCubit.data?.area,
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
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 26),
                      ),
                      SliverToBoxAdapter(
                          child: Text(localizations.photo,
                              style: AppTypography.font18black)),
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
                                final place =
                                    placeManager.searchPlaceIdByName(_place);
                                announcementEditCubit.onPlaceChange(place);

                                announcementEditCubit.saveChanges();
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
