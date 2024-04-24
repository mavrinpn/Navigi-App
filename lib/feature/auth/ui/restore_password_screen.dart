import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
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

class RestorePasswordScreen extends StatefulWidget {
  const RestorePasswordScreen({Key? key}) : super(key: key);

  @override
  State<RestorePasswordScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RestorePasswordScreen> {
  final phoneController = TextEditingController();
  final firstPasswordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isTouch = false;

  bool checkFields(String phone, String firstPassword, String secondPassword) {
    return phone.length == 9 && firstPassword == secondPassword && firstPassword.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final localizations = AppLocalizations.of(context)!;

    void checkIsTouch() {
      if (checkFields(
        maskPhoneFormatter.getUnmaskedText(),
        firstPasswordController.text,
        secondPasswordController.text,
      )) {
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
        } else if (state is NotFoundState) {
          Navigator.of(context).pushReplacementNamed(AppRoutesNames.userExist);
          // CustomSnackBar.showSnackBar(context, 'Use was already register');
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.appBarColor,
            titleSpacing: 6,
            title: const Row(
              children: [
                CustomBackButton(),
              ],
            ),
          ),
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
                        localizations.recoverPassword,
                        style: AppTypography.font24black.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 30),
                      MaskTextFormField(
                        controller: phoneController,
                        hintText: '+213 (###) ## ## ##',
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        prefIcon: 'Assets/icons/phone.svg',
                        validator: (value) {
                          if (maskPhoneFormatter.getUnmaskedText().length != 9) {
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
                            if (value! != secondPasswordController.text || value.length < 8) {
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
                          if (value! != firstPasswordController.text || value.length < 8) {
                            return localizations.errorReviewOrEnterOther;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          checkIsTouch();
                        },
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
                          BlocProvider.of<AuthCubit>(context).restorePassword(
                            phone: maskPhoneFormatter.getUnmaskedText(),
                            password: firstPasswordController.text.trim(),
                          );

                          Navigator.pushNamed(
                            context,
                            AppRoutesNames.checkCode,
                            arguments: {'isPasswordRestore': true},
                          );
                        },
                        text: localizations.next,
                        styleText: AppTypography.font14white,
                        height: 52,
                        active: isTouch,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        activeColor: AppColors.dark,
                      ),
                      const SizedBox(height: 40),
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
}
