import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/auth/bloc/auth_cubit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../widgets/button/custom_text_button.dart';
import '../../../widgets/textField/mask_text_field.dart';

final maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+213 (###) ## ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

class LoginFirstScreen extends StatefulWidget {
  const LoginFirstScreen({Key? key}) : super(key: key);

  @override
  State<LoginFirstScreen> createState() => _LoginFirstScreenState();
}

class _LoginFirstScreenState extends State<LoginFirstScreen> {
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isError = false;

  bool isTouch = false;

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
                    'Lorem lobortis mi ornare nisi tellus sed aliquam accuornare nis',
                    style: AppTypography.font14lightGray,
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MaskTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          width: width * 0.95,
                          prefIcon: 'Assets/icons/phone.svg',
                          mask: maskPhoneFormatter,
                          hintText: '+213 (###) ## ## ##',
                          validator: (value) {
                            if (maskPhoneFormatter.getUnmaskedText().length !=
                                9) {
                              return 'Erreur! Réessayez ou entrez dautres informations.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (maskPhoneFormatter.getUnmaskedText().length ==
                                9) {
                              isTouch = true;
                              setState(() {});
                              return;
                            }
                            isTouch = false;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: height * 0.18,
                        ),
                        CustomTextButton(
                          callback: () {
                            if (!_formKey.currentState!.validate()) {
                              isError = true;
                              setState(() {});
                              return;
                            }
                            if (isTouch) {
                              final bloc = BlocProvider.of<AuthCubit>(context);
                              bloc.setPhone(
                                  maskPhoneFormatter.getUnmaskedText());
                              print('set phone ${maskPhoneFormatter.getMaskedText()}');
                              Navigator.pushNamed(
                                  context, AppRoutesNames.loginSecond);
                              print('push');
                            }
                          },
                          text: AppLocalizations.of(context)!.next,
                          styleText: AppTypography.font14white,
                          height: 52,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          active: isTouch,
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
                          text: localizations.dontHaveAnAccount,
                          style: AppTypography.font14lightGray
                              .copyWith(fontSize: 16)),
                      TextSpan(
                          text: localizations.createNewAccount,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register_screen');
                            },
                          style: AppTypography.font16UnderLinePink)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                          onPressed: () {},
                          shape: const CircleBorder(),
                          constraints:
                              const BoxConstraints(maxWidth: 40, maxHeight: 40),
                          child: SvgPicture.asset(
                            'Assets/icons/facebook.svg',
                            width: 40,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      RawMaterialButton(
                          constraints:
                              const BoxConstraints(maxWidth: 40, maxHeight: 40),
                          onPressed: () {},
                          shape: const CircleBorder(),
                          child: SvgPicture.asset(
                            'Assets/icons/google.svg',
                            width: 40,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
