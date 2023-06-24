import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/textField/custom_text_field.dart';

class LoginFirstScreen extends StatefulWidget {
  const LoginFirstScreen({Key? key}) : super(key: key);

  @override
  State<LoginFirstScreen> createState() => _LoginFirstScreenState();
}

class _LoginFirstScreenState extends State<LoginFirstScreen> {
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 230,
                height: 62,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/logo.png"), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Bienvenue!',
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
                      CustomTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        isError: isError,
                        prefIcon: 'Assets/Phone.png',
                      ),
                      SizedBox(
                        height: height * 0.18,
                      ),
                      CustomElevatedButton(
                        callback: () {
                          if (_formKey.currentState!.validate()) {
                            isError = true;
                            setState(() {});
                          }

                          Navigator.pushNamed(context, '/login_second_screen');
                        },
                        text: 'Entrer',
                        styleText: AppTypography.font14white,
                        height: 52,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
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
                        text: 'Pas de compte? ',
                        style: AppTypography.font14lightGray
                            .copyWith(fontSize: 16)),
                    TextSpan(
                        text: 'Inscrivez-vous!',
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
                      child:
                          const Image(image: AssetImage('Assets/facebook.png')),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    RawMaterialButton(
                      constraints:
                          const BoxConstraints(maxWidth: 40, maxHeight: 40),
                      onPressed: () {},
                      shape: const CircleBorder(),
                      child:
                          const Image(image: AssetImage('Assets/google.png')),
                    ),
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
    );
  }
}
