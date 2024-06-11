import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/functions.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/textField/mask_text_field.dart';

import '../../../widgets/images/network_image.dart';
import '../../../widgets/snackBar/snack_bar.dart';
import '../../../widgets/textField/custom_text_field.dart';
import '../../auth/data/auth_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  bool isButtonActive = false;
  bool isPhoneValid = false;

  CroppedFile? image;

  Uint8List? bytes;
  // String? changedName;
  // String? phone;

  void pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = await ImageCropper().cropImage(
        sourcePath: file!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        compressQuality: 50,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.dark,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      bytes = await image?.readAsBytes();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    final userRepo = RepositoryProvider.of<AuthRepository>(context);

    nameController.text = userRepo.userData?.name ?? '';
    phoneController.text = maskPhoneFormatter.maskText(userRepo.userData?.phone ?? '');
    emailController.text = userRepo.loggedUser?.email ?? '';

    isPhoneValid = maskPhoneFormatter.getUnmaskedText().length == 9;
    _checkActiveButton();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final user = RepositoryProvider.of<AuthRepository>(context).userData;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          automaticallyImplyLeading: false,
          titleSpacing: 6,
          title: Row(
            children: [
              const CustomBackButton(),
              const SizedBox(width: 13),
              Text(
                localizations.myData,
                style: AppTypography.font20black,
              ),
            ],
          ),
        ),
        body: BlocListener<UserCubit, UserState>(
            listener: (context, state) {
              if (state is ProfileLoadingState) {
                Dialogs.showModal(
                    context,
                    Center(
                      child: AppAnimations.circleFadingAnimation,
                    ));
              } else {
                Dialogs.hide(context);
              }
              if (state is EditSuccessState) {
                CustomSnackBar.showSnackBarWithIcon(
                  context: context,
                  text: localizations.withSuccess,
                  iconAsset: 'Assets/icons/heart_out_line.svg',
                );
              } else if (state is EditFailState) {
                CustomSnackBar.showSnackBar(context, 'Essayez plus tard');
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: pickImage,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                image == null
                                    ? CustomNetworkImage(
                                        width: 100,
                                        height: 100,
                                        url: user?.imageUrl ?? '',
                                        borderRadius: 50,
                                      )
                                    : ClipOval(child: Image.memory(bytes!, width: 100)),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50), color: Colors.black.withOpacity(0.3)),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'Assets/icons/camera.svg',
                                      width: 32,
                                      height: 32,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        CustomTextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          prefIcon: 'Assets/icons/profile.svg',
                          onChanged: (value) {
                            // changedName = o != user?.name ? o : null;
                          },
                        ),
                        PhoneTextFormField(
                          controller: phoneController,
                          hintText: '+213 (###) ## ## ##',
                          keyboardType: TextInputType.phone,
                          prefIcon: 'Assets/icons/phone.svg',
                          validator: (value) {
                            if (maskPhoneFormatter.getUnmaskedText().length != 9) {
                              return localizations.errorReviewOrEnterOther;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            isPhoneValid = maskPhoneFormatter.getUnmaskedText().length == 9;
                            _checkActiveButton();
                          },
                          mask: maskPhoneFormatter,
                        ),
                        // CustomTextFormField(
                        //   controller: phoneController,
                        //   keyboardType: TextInputType.text,
                        //   prefIcon: 'Assets/icons/phone.svg',
                        //   onChanged: (String? o) {
                        //     phone = o != user?.phone ? o : null;
                        //   },
                        // ),
                        CustomTextFormField(
                          readOnly: true,
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          prefIcon: 'Assets/icons/email.svg',
                          onChanged: (String? o) {},
                        ),
                        CustomTextFormField(
                          controller: placeController,
                          keyboardType: TextInputType.text,
                          prefIcon: 'Assets/icons/point2.svg',
                          onChanged: (String? o) {},
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CustomTextButton(
                          callback: () {
                            if (isButtonActive) {
                              BlocProvider.of<UserCubit>(context).editProfile(
                                name: nameController.text.trim(),
                                phone: maskPhoneFormatter.getUnmaskedText(),
                                bytes: bytes,
                              );
                            }
                          },
                          text: localizations.save,
                          styleText: AppTypography.font14white.copyWith(fontWeight: FontWeight.w600),
                          active: isButtonActive,
                          activeColor: AppColors.black,
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _checkActiveButton() {
    if (isPhoneValid) {
      isButtonActive = true;
    } else {
      isButtonActive = false;
    }
    setState(() {});
  }
}
