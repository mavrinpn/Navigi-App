import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../data/auth_repository.dart';
import '../../../widgets/images/network_image.dart';
import '../../../widgets/textField/custom_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = RepositoryProvider.of<AuthRepository>(context).userData;

    nameController.text = user.name;
    phoneController.text = user.phone;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: 30,
                  height: 48,
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                  )),
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              'Mes données',
              style: AppTypography.font20black,
            ),
          ],
        ),
      ),
      body: Center(
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
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        CustomNetworkImage(
                          width: 100,
                          height: 100,
                          url: user.imageUrl,
                          borderRadius: 50,
                        ),
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
                  CustomTextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    prefIcon: 'Assets/icons/profile.svg',
                    onChanged: (String? o) {},
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.text,
                    prefIcon: 'Assets/icons/phone.svg',
                    onChanged: (String? o) {},
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
                      callback: () {},
                      text: 'Enregistrer',
                      styleText: AppTypography.font14white
                          .copyWith(fontWeight: FontWeight.w600),
                      isTouch: true,
                    activeColor: AppColors.black,
                  ),
                  SizedBox(height: 30,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
