import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/feature/create_announcement/ui/widgets/select_location_widget.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/functions.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';
import 'package:smart/widgets/textField/custom_text_field.dart';
import 'package:smart/widgets/textField/mask_text_field.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  State<UserDataScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<UserDataScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isNameValid = false;
  bool isPhoneValid = false;
  bool isButtonActive = false;
  bool isTapCheckBox = false;

  String _cityTitle = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState || state is UserCreatingState) {
          Dialogs.showModal(context, Center(child: AppAnimations.bouncingLine));
        } else {
          Dialogs.hide(context);
        }
        if (state is AuthSuccessState) {
          Navigator.pop(context);
        } else if (state is AuthFailState) {
          CustomSnackBar.showSnackBar(context, 'Error with database');
        } else if (state is UserAlreadyExistState) {
          Navigator.of(context).pushNamed(AppRoutesNames.userExist);
        } else if (state is UserSuccessCreatedState) {
          Navigator.pushNamed(
            context,
            AppRoutesNames.authCode,
            arguments: {'isPasswordRestore': false},
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      isNameValid = (value ?? '').isNotEmpty;
                      _checkActiveButton();
                    },
                  ),
                  PhoneTextFormField(
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
                      isPhoneValid = maskPhoneFormatter.getUnmaskedText().length == 9;
                      _checkActiveButton();
                    },
                    mask: maskPhoneFormatter,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: SelectLocationWidget(
                      showMapButton: false,
                      onSetActive: (value) {},
                      onChangeCity: (name) {
                        _cityTitle = name;
                      },
                      onChangeDistrict: (cityDistrict) {
                        _setDistrinct(
                          distrinct: cityDistrict,
                          cityTitle: _cityTitle,
                        );
                      },
                      isProfile: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                                side: const BorderSide(width: 1, color: AppColors.lightGray),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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
                              localizations.jacceptsTheConditionsForTheilization,
                              style: AppTypography.font14black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton(
                    callback: () {
                      if (!_formKey.currentState!.validate() || !isButtonActive) {
                        setState(() {});
                        return;
                      }

                      BlocProvider.of<AuthCubit>(context).setUserData(
                        name: nameController.text.trim(),
                        phone: maskPhoneFormatter.getUnmaskedText(),
                      );
                    },
                    text: localizations.regg,
                    styleText: AppTypography.font14white,
                    height: 52,
                    active: isButtonActive,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    activeColor: AppColors.dark,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    child: Text(
                      localizations.cancelation,
                      style: AppTypography.font16UnderLinePink,
                    ),
                    onTap: () {
                      context.read<AppCubit>().resetLogin();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _checkActiveButton() {
    if (isPhoneValid && isNameValid && isTapCheckBox) {
      isButtonActive = true;
    } else {
      isButtonActive = false;
    }
    setState(() {});
  }

  _checkBoxPressed() {
    isTapCheckBox = !isTapCheckBox;
    _checkActiveButton();
  }

  _setDistrinct({
    required CityDistrict distrinct,
    required String cityTitle,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cityDistrictKey, jsonEncode(distrinct.toMap(cityTitle)));
  }
}
