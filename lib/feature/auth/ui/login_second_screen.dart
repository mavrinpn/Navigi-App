import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart/feature/announcement/bloc/creator_cubit/creator_cubit.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

import '../../../utils/dialogs.dart';
import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/textField/custom_text_field.dart';

class LoginSecondScreen extends StatefulWidget {
  const LoginSecondScreen({Key? key}) : super(key: key);

  @override
  State<LoginSecondScreen> createState() => _LoginSecondScreenState();
}

class _LoginSecondScreenState extends State<LoginSecondScreen> {
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool buttonActive = false;

  bool passwordError = false;

  @override
  Widget build(BuildContext context) {
    GlobalKey buttonKey = GlobalKey();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bloc = BlocProvider.of<AuthCubit>(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          Dialogs.showModal(context, Center(child: AppAnimations.circleFadingAnimation));
        } else {
          Dialogs.hide(context);
        }
        if (state is AuthSuccessState) {
          BlocProvider.of<CreatorCubit>(context).setUserId(RepositoryProvider.of<AuthRepository>(context).userId);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is AuthFailState) {
          CustomSnackBar.showSnackBar(context, AppLocalizations.of(context)!.passwordOrEmailEnteredIncorrectly);
        } else if (state is AuthUserNotVerificated) {
          Navigator.pushNamed(
            context,
            AppRoutesNames.authCode,
            arguments: {'isPasswordRestore': false},
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'Assets/icons/logo.svg',
                    width: 195,
                    height: 43,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    localizations.hello,
                    style: AppTypography.font24black,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      localizations.loremLobortisMi,
                      style: AppTypography.font14lightGray,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            width: width * 0.95,
                            prefIcon: 'Assets/icons/key.svg',
                            obscureText: true,
                            validator: (value) {
                              if (value!.length < 8 || passwordError) {
                                return localizations.errorReviewOrEnterOther;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value!.length > 7) {
                                buttonActive = true;
                                setState(() {});
                                return;
                              }
                              buttonActive = false;
                              setState(() {});
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutesNames.restorePassword,
                              );
                            },
                            child: Text(localizations.forgotYourPassword),
                          ),
                          SizedBox(
                            height: height * 0.14,
                          ),
                          CustomTextButton(
                            key: buttonKey,
                            callback: () {
                              if (!_formKey.currentState!.validate()) {
                                setState(() {});
                                return;
                              }

                              if (buttonActive) {
                                //bloc.loginWithPhone(password: passwordController.text.trim());
                                bloc.loginWithEmail(password: passwordController.text.trim());
                              }
                            },
                            active: buttonActive,
                            text: localizations.enter,
                            styleText: AppTypography.font14white,
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: localizations.noAccount, style: AppTypography.font14lightGray.copyWith(fontSize: 16)),
                        TextSpan(
                            text: localizations.register,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/register_screen');
                              },
                            style: AppTypography.font16UnderLinePink)
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       RawMaterialButton(
                  //           onPressed: () {},
                  //           shape: const CircleBorder(),
                  //           constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
                  //           child: SvgPicture.asset(
                  //             'Assets/icons/facebook.svg',
                  //             width: 40,
                  //           )),
                  //       const SizedBox(width: 5),
                  //       RawMaterialButton(
                  //           constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
                  //           onPressed: () {},
                  //           shape: const CircleBorder(),
                  //           child: SvgPicture.asset(
                  //             'Assets/icons/google.svg',
                  //             width: 40,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 60,
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
