import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/main.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../models/custom_locate.dart';
import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/dropDownSingleCheckBox/custom_dropdown_single_checkbox.dart';
import '../../../widgets/singleCheckBox/CustomSinglCheckBox.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../../../widgets/textField/under_line_text_field.dart';

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
  CustomLocate? customLocate;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final priseController = TextEditingController(text: '0');
    bool isTouch = true;
    final _formKey = GlobalKey<FormState>();
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    Future addImages() async {
      await repository.pickImages();
      setState(() {});
    }

    titleController.text = repository.creatingData.title!;

    descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: descriptionController.text.length));
    titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: titleController.text.length));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              focusColor: AppColors.empty,
              hoverColor: AppColors.empty,
              highlightColor: AppColors.empty,
              splashColor: AppColors.empty,
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 35,
                height: 48,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.price,
              style: AppTypography.font18black,
            ),
            UnderLineTextField(
              width: double.infinity,
              hintText: '',
              controller: priseController,
              keyBoardType: TextInputType.number,
              validator: (value) {
                double? n;
                try {
                  n = double.parse(priseController.text);
                } catch (e) {
                  n = -1;
                }
                if (n < 0 || n > 20000000) {
                  isTouch = false;
                  return localizations.errorReviewOrEnterOther;
                }
                isTouch = true;
                return null;
              },
              onChange: (String value) {
                setState(() {
                  _formKey.currentState!.validate();
                });
              },
              onEditingComplete: () {
                setState(() {
                  priseController.text =
                      double.parse(priseController.text).toString();
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onTapOutside: (e) {
                setState(() {
                  priseController.text =
                      double.parse(priseController.text).toString();
                });
                FocusScope.of(context).requestFocus(FocusNode());
              },
              suffixIcon: 'DZD',
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
                child: Column(
              children: (repository.currentItem != null
                      ? repository
                          .currentItem!.parameters.variableParametersList
                      : [])
                  .map((e) => CustomDropDownSingleCheckBox(
                        parameters: e,
                        onChange: (String? value) {
                          e.setVariant(value!);
                          setState(() {});
                        },
                        currentVariable: e.currentValue,
                      ))
                  .toList(),
            )),


            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            localizations.title,
                            style: AppTypography.font16black.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        OutLineTextField(
                          hintText: localizations.name,
                          controller: titleController,
                          maxLines: 5,
                          height: 100,
                          width: double.infinity,
                          maxLength: 100,
                          onChange: (value) {
                            if (value.isNotEmpty) {
                              repository.setTitle(value);
                            } else {
                              repository.setTitle(repository.buildTitle);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            localizations.description,
                            style: AppTypography.font16black.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        OutLineTextField(
                          hintText: localizations.description,
                          controller: descriptionController,
                          maxLines: 20,
                          height: 310,
                          width: double.infinity,
                          maxLength: 500,
                          onChange: (value) {
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(
              height: 26,
            ),
            Text(
                localizations.photo,
                style: AppTypography.font18black),
            const SizedBox(
              height: 26,
            ),
            !repository.images.isNotEmpty
                ? CustomTextButton.withIcon(
                    active: true,
                    activeColor: AppColors.dark,
                    callback: () {
                      addImages();
                    },
                    text: localizations.addPictures,
                    styleText: AppTypography.font14white,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : Expanded(
                    //height: MediaQuery.of(context).size.height - 320,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast),
                      itemCount: repository.images.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 113,
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 7,
                              crossAxisCount: 3),
                      itemBuilder: (_, int index) {
                        if (index != repository.images.length) {
                          return ImageWidget(
                            path: repository.images[index].path,
                            callback: () {
                              repository.images.removeAt(index);
                              setState(() {});
                            },
                          );
                        } else {
                          return AddImageWidget(
                            callback: addImages,
                          );
                        }
                      },
                    ),
                  ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}



class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.path, required this.callback});

  final String path;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113,
      height: 106,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 105,
              height: 98,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.red,
                  image: DecorationImage(
                      image: FileImage(File(path)), fit: BoxFit.cover)),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(right: 6),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: callback,
                child: SvgPicture.asset(
                  'Assets/icons/delete_button.svg',
                  width: 27,
                ),
              )),
        ],
      ),
    );
  }
}

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 105,
        height: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.backgroundLightGray,
        ),
        child: Center(
          child: SvgPicture.asset(
            'Assets/icons/add_image.svg',
            width: 32,
          ),
        ),
      ),
    );
  }
}

class ImagePreparingWidget extends StatelessWidget {
  const ImagePreparingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 98,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.backgroundLightGray,
      ),
      child: Center(child: AppAnimations.bouncingLine),
    );
  }
}