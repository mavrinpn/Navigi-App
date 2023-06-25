import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/textField/custom_text_field.dart';

class LoginSecondScreen extends StatefulWidget {
  const LoginSecondScreen({Key? key}) : super(key: key);

  @override
  State<LoginSecondScreen> createState() => _LoginSecondScreenState();
}

class _LoginSecondScreenState extends State<LoginSecondScreen> {
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isTouch = false;

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
                        controller: passwordController,
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        prefIcon: 'Assets/icons/key.svg',
                        obscureText: true,
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'Erreur! Réessayez ou entrez dautres informations.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value!.length > 8) {
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
                      CustomElevatedButton(
                        callback: () {
                          if (!_formKey.currentState!.validate()) {
                            setState(() {});
                            return;
                          }

                          if (isTouch) {
                            Navigator.pushNamed(context, '/home_screen');
                          }
                        },
                        isTouch: isTouch,
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
