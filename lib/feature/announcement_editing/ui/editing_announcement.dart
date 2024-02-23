import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement_editing/bloc/announcement_edit_cubit.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/description.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/parameters.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/price.dart';
import 'package:smart/feature/announcement_editing/ui/widgets/title.dart';
import 'package:smart/feature/create_announcement/ui/widgets/add_image.dart';
import 'package:smart/feature/create_announcement/ui/widgets/image.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../models/custom_locate.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';

class EditingAnnouncement extends StatefulWidget {
  const EditingAnnouncement({super.key});

  @override
  State<EditingAnnouncement> createState() => _EditingAnnouncementState();
}

List<CustomLocate> listLocates = [
  CustomLocate.fr(),
  CustomLocate.ar(),
];

class _EditingAnnouncementState extends State<EditingAnnouncement> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialTextFields();
  }

  CustomLocate? customLocate;
  bool buttonActive = true;

  String? priceValidator(String? value) {
    final localizations = AppLocalizations.of(context)!;
    final cubit = BlocProvider.of<AnnouncementEditCubit>(context);
    double? n;
    n = double.tryParse(priceController.text) ?? -1;
    if (n < 0 || n > 20000000) {
      buttonActive = false;
      return localizations.errorReviewOrEnterOther;
    }
    buttonActive = true && cubit.images.isNotEmpty;
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

    priceValidator(priceController.text);
  }

  void initialTextFields() {
    final cubit = RepositoryProvider.of<AnnouncementEditCubit>(context);
    titleController.text = cubit.data.title;
    descriptionController.text = cubit.data.description;
    priceController.text = cubit.data.price.toString();
  }

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateTextSelection();
    final cubit = context.read<AnnouncementEditCubit>();
    final localizations = AppLocalizations.of(context)!;
    return PopScope(
        canPop: true,
        onPopInvoked: (v) {
          cubit.closeEdit();
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
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('success')));
            } else if (state is AnnouncementEditFail) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('fail')));
            }
          },
          builder: (context, state) {
            validateButtonActive();

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.empty,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(callback: () {
                      cubit.closeEdit();
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
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomScrollView(
                  slivers: [
                    PriceSection(
                      onChange: (String value) {
                        cubit.onPriceChanged(value);
                        setState(() {
                          formKey.currentState!.validate();
                        });
                      },
                      priceController: priceController,
                      priceValidator: priceValidator,
                      localizations: localizations,
                      savePrice: savePrice,
                    ),
                    ParametersSection(cubit: cubit),
                    TitleSection(
                      titleController: titleController,
                      onChange: (v) {
                        if ((v ?? '').isEmpty) {
                          setState(() {
                            buttonActive = false;
                          });
                        } else {
                          cubit.onTitleChange(v);
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
                            cubit.onDescriptionChanged(v);
                          }
                        }),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 26,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Text(localizations.photo,
                            style: AppTypography.font18black)),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 26,
                      ),
                    ),
                    buildImagesSection(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 32,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CustomTextButton.orangeContinue(
                          active: buttonActive,
                          callback: () {
                            if (buttonActive) {
                              cubit.saveChanges();
                            }
                          },
                          text: localizations.save),
                    )
                  ],
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
                childCount: cubit.images.length + 1, (_, int index) {
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
            }),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 106,
                childAspectRatio: 0.938,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
                crossAxisCount: 3));
  }
}
