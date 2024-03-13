import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

import '../../../utils/animations.dart';
import '../../../utils/colors.dart';
import '../../../utils/dialogs.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/textField/custom_text_field.dart';
import '../../../widgets/textField/mask_text_field.dart';

final maskPhoneFormatter = MaskTextInputFormatter(
  mask: '+213 (###) ## ## ##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final firstPasswordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isTouch = false;
  bool isTapCheckBox = false;

  bool checkFields(
      String phone, String name, String firstPassword, String secondPassword) {
    return phone.length == 9 &&
        name.isNotEmpty &&
        firstPassword == secondPassword &&
        firstPassword.length >= 8 &&
        isTapCheckBox;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final localizations = AppLocalizations.of(context)!;

    void checkIsTouch() {
      if (checkFields(maskPhoneFormatter.getUnmaskedText(), nameController.text,
          firstPasswordController.text, secondPasswordController.text)) {
        isTouch = true;
        setState(() {});
        return;
      }
      isTouch = false;
      setState(() {});
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          Dialogs.showModal(context, Center(child: AppAnimations.bouncingLine));
        } else {
          Dialogs.hide(context);
        }
        if (state is AuthSuccessState) {
          Navigator.pop(context);
        } else if (state is AuthFailState) {
          CustomSnackBar.showSnackBar(context, 'Error with database');
        } else if (state is AlreadyExistState) {
          CustomSnackBar.showSnackBar(context, 'Use was already register');
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: height * 0.05),
                      SvgPicture.asset(
                        'Assets/icons/logo.svg',
                        width: 195,
                        height: 43,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        localizations.registration,
                        style: AppTypography.font24black.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      CustomTextFormField(
                          controller: nameController,
                          hintText: localizations.yourName,
                          keyboardType: TextInputType.text,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/profile.svg',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return localizations.errorReviewOrEnterOther;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            checkIsTouch();
                          }),
                      MaskTextFormField(
                        controller: phoneController,
                        hintText: '+213 (###) ## ## ##',
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        prefIcon: 'Assets/icons/phone.svg',
                        validator: (value) {
                          if (maskPhoneFormatter.getUnmaskedText().length !=
                              9) {
                            return localizations.errorReviewOrEnterOther;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          checkIsTouch();
                        },
                        mask: maskPhoneFormatter,
                      ),
                      CustomTextFormField(
                          controller: firstPasswordController,
                          hintText: localizations.createPassword,
                          keyboardType: TextInputType.text,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/key.svg',
                          obscureText: true,
                          validator: (value) {
                            if (value! != secondPasswordController.text ||
                                value.length < 8) {
                              return localizations.errorReviewOrEnterOther;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            checkIsTouch();
                          }),
                      CustomTextFormField(
                          controller: secondPasswordController,
                          keyboardType: TextInputType.text,
                          hintText: localizations.repeatePassword,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/key.svg',
                          obscureText: true,
                          validator: (value) {
                            if (value! != firstPasswordController.text ||
                                value.length < 8) {
                              return localizations.errorReviewOrEnterOther;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            checkIsTouch();
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: GestureDetector(
                          onTap: _checkBoxPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    splashRadius: 2,
                                    checkColor: Colors.white,
                                    activeColor: AppColors.red,
                                    side: const BorderSide(
                                        width: 1, color: AppColors.lightGray),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    value: isTapCheckBox,
                                    onChanged: (bool? value) {
                                      _checkBoxPressed();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              SizedBox(
                                width: width - 75,
                                child: Text(
                                  localizations
                                      .jacceptsTheConditionsForTheilization,
                                  style: AppTypography.font14black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      CustomTextButton(
                        callback: () {
                          if (!_formKey.currentState!.validate() || !isTouch) {
                            setState(() {});
                            return;
                          }
                          BlocProvider.of<AuthCubit>(context).registerWithPhone(
                              phone: maskPhoneFormatter.getUnmaskedText(),
                              name: nameController.text.trim(),
                              password: firstPasswordController.text.trim());

                          Navigator.pushNamed(
                              context, AppRoutesNames.checkCode);
                        },
                        text: localizations.regg,
                        styleText: AppTypography.font14white,
                        height: 52,
                        active: isTouch,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        activeColor: AppColors.dark,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        child: Text(localizations.entrance,
                            style: AppTypography.font16UnderLinePink),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _checkBoxPressed() {
    setState(() {
      isTapCheckBox = !isTapCheckBox;
    });

    if (checkFields(maskPhoneFormatter.getUnmaskedText(), nameController.text,
        firstPasswordController.text, secondPasswordController.text)) {
      isTouch = true;
      setState(() {});
      return;
    }
    isTouch = false;
    setState(() {});
  }
}
