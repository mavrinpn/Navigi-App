import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/snackBar/snack_bar.dart';

import '../../../utils/dialogs.dart';
import '../../../widgets/button/custom_text_button.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({
    Key? key,
    required this.isPasswordRestore,
  }) : super(key: key);

  final bool isPasswordRestore;

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  final codeController = TextEditingController();
  bool buttonActive = false;
  final int codeLength = 4;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
          Navigator.popUntil(context, ModalRoute.withName(AppRoutesNames.root));
        } else if (state is AuthFailState) {
          CustomSnackBar.showSnackBar(context, AppLocalizations.of(context)!.passwordOrEmailEnteredIncorrectly);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: AppColors.appBarColor,
            automaticallyImplyLeading: false,
            titleSpacing: 6,
            title: const Row(
              children: [
                CustomBackButton(),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    Image.asset(
                      'Assets/logo2.png',
                      width: 60,
                      height: 65,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      localizations.confirmation,
                      style: AppTypography.font24black,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: width * 0.6,
                      child: Text(
                        localizations.enterCode,
                        style: AppTypography.font14lightGray,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 16,
                ),
                Pinput(
                  controller: codeController,
                  length: codeLength,
                  onCompleted: (v) {
                    setState(() {
                      buttonActive = true;
                    });
                  },
                  onChanged: (v) {
                    buttonActive = v.length == codeLength;
                  },
                  defaultPinTheme: const PinTheme(
                      width: 56,
                      height: 60,
                      textStyle: TextStyle(
                        fontSize: 22,
                        color: AppColors.dark,
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.darkGrayUnderline, width: 1)),
                      )),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: localizations.haventRecieveCode,
                          style: AppTypography.font14lightGray.copyWith(fontSize: 16)),
                      TextSpan(
                          text: localizations.sendAgain,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //send retry
                            },
                          style: AppTypography.font16UnderLinePink)
                    ],
                  ),
                ),
                const Spacer(
                  flex: 24,
                ),
                CustomTextButton(
                  callback: () {
                    if (buttonActive) {
                      bloc
                          .confirmCode(
                        code: codeController.text,
                        isPasswordRestore: widget.isPasswordRestore,
                      )
                          .timeout(
                        const Duration(seconds: 4),
                        onTimeout: () {
                          Navigator.of(context).pop();
                          CustomSnackBar.showSnackBar(context, localizations.tryAgainLater);
                        },
                      );
                    }
                  },
                  active: buttonActive,
                  text: localizations.afterwards,
                  styleText: AppTypography.font14white,
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                ),
                const Spacer(
                  flex: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
