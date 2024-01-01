import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/profile/bloc/user_cubit.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/dialogs.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../widgets/images/network_image.dart';
import '../../../widgets/snackBar/snack_bar.dart';
import '../../../widgets/textField/custom_text_field.dart';
import '../../auth/data/auth_repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  CroppedFile? image;

  Uint8List? bytes;
  String? changedName;
  String? phone;

  void pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    final user = RepositoryProvider.of<AuthRepository>(context).userData;

    nameController.text = user.name;
    phoneController.text = user.phone;

    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                    width: 30,
                    height: 48,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                    )),
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                localizations.myInformations,
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
                    context, 'Avec succès', 'Assets/icons/heart_out_line.svg');
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
                                        url: user.imageUrl,
                                        borderRadius: 50,
                                      )
                                    : ClipOval(
                                        child:
                                            Image.memory(bytes!, width: 100)),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black.withOpacity(0.3)),
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
                          onChanged: (String? o) {
                            changedName = o != user.name ? o : null;
                          },
                        ),
                        CustomTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.text,
                          prefIcon: 'Assets/icons/phone.svg',
                          onChanged: (String? o) {
                            phone = o != user.phone ? o : null;
                          },
                        ),
                        CustomTextFormField(
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
                            BlocProvider.of<UserCubit>(context).editProfile(
                                name: changedName, phone: phone, bytes: bytes);
                          },
                          text: 'Enregistrer',
                          styleText: AppTypography.font14white
                              .copyWith(fontWeight: FontWeight.w600),
                          active: true,
                          activeColor: AppColors.black,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
