import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/textField/custom_text_field.dart';

import '../../../widgets/button/custom_text_button.dart';

// final maskPhoneFormatter = MaskTextInputFormatter(
//   mask: '+213 (###) ## ## ##',
//   filter: {"#": RegExp(r'[0-9]')},
//   type: MaskAutoCompletionType.lazy,
// );

class LoginFirstScreen extends StatefulWidget {
  const LoginFirstScreen({
    Key? key,
    required this.showBackButton,
  }) : super(key: key);

  final bool showBackButton;

  @override
  State<LoginFirstScreen> createState() => _LoginFirstScreenState();
}

class _LoginFirstScreenState extends State<LoginFirstScreen> {
  // final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonActive = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widget.showBackButton
            ? AppBar(
                automaticallyImplyLeading: true,
                leading: const CustomBackButton(),
              )
            : null,
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
                  AppLocalizations.of(context)!.hello,
                  style: AppTypography.font24black,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: width * 0.6,
                  child: Text(
                    AppLocalizations.of(context)!.connectToDiscoverFeatures,
                    style: AppTypography.font14lightGray,
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // MaskTextFormField(
                        //   controller: phoneController,
                        //   keyboardType: TextInputType.phone,
                        //   width: width * 0.95,
                        //   prefIcon: 'Assets/icons/phone.svg',
                        //   mask: maskPhoneFormatter,
                        //   hintText: '+213 (###) ## ## ##',
                        //   validator: (value) {
                        //     if (maskPhoneFormatter.getUnmaskedText().length != 9) {
                        //       return localizations.errorIncorrectInfo;
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) {
                        //     if (maskPhoneFormatter.getUnmaskedText().length == 9) {
                        //       isTouch = true;
                        //       setState(() {});
                        //       return;
                        //     }
                        //     isTouch = false;
                        //     setState(() {});
                        //   },
                        // ),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: 'E-mail',
                          keyboardType: TextInputType.text,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/email.svg',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return localizations.errorReviewOrEnterOther;
                            }
                            if (!EmailValidator.validate(value)) {
                              return localizations.enterValidEmail;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            isButtonActive = _formKey.currentState?.validate() ?? false;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: height * 0.18),
                        CustomTextButton(
                          callback: () {
                            if (!_formKey.currentState!.validate()) {
                              isError = true;
                              setState(() {});
                              return;
                            }
                            if (isButtonActive) {
                              final bloc = BlocProvider.of<AuthCubit>(context);
                              //bloc.setPhoneForLogin(maskPhoneFormatter.getUnmaskedText());
                              bloc.setEmailForLogin(emailController.text.trim());
                              Navigator.pushNamed(context, AppRoutesNames.loginSecond);
                            }
                          },
                          text: AppLocalizations.of(context)!.enter,
                          styleText: AppTypography.font14white,
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          active: isButtonActive,
                        ),
                      ],
                    )),
                const SizedBox(height: 16),
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
                //       const SizedBox(
                //         width: 5,
                //       ),
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
    );
  }
}
