import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';

import '../../../widgets/button/custom_text_button.dart';

class CheckCodeScreen extends StatefulWidget {
  const CheckCodeScreen({
    Key? key,
    required this.isPasswordRestore,
  }) : super(key: key);

  final bool isPasswordRestore;

  @override
  State<CheckCodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CheckCodeScreen> {
  final codeController = TextEditingController();
  bool buttonActive = false;
  final int codeLength = 4;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
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
        elevation: 0,
        scrolledUnderElevation: 0,
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
                const SizedBox(height: 35),
                Text(
                  localizations.confirmation,
                  style: AppTypography.font24black,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: width * 0.6,
                  child: Text(
                    localizations.checkPhone,
                    style: AppTypography.font14lightGray,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('Assets/iphone_bezel.png'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          localizations.enterFourDigits,
                          textAlign: TextAlign.center,
                          style: AppTypography.font12black,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+213 (550) 72',
                              style: AppTypography.font16black,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '3089',
                              style: AppTypography.font16boldRed.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomTextButton(
              callback: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutesNames.authCode,
                  arguments: {'isPasswordRestore': widget.isPasswordRestore},
                );
              },
              active: true,
              text: localizations.callMe,
              styleText: AppTypography.font14white,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              activeColor: AppColors.dark,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
