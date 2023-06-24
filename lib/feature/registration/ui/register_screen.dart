import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/textField/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final firstPasswordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isError = false;

  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      width: 124,
                      height: 34,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("Assets/logo.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Enregistrement',
                      style: AppTypography.font24black.copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.phone,
                      width: width * 0.95,
                      isError: isError,
                      prefIcon: 'Assets/People.png',
                    ),
                    CustomTextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      width: width * 0.95,
                      isError: isError,
                      prefIcon: 'Assets/Phone.png',
                    ),
                    CustomTextFormField(
                      controller: firstPasswordController,
                      keyboardType: TextInputType.phone,
                      width: width * 0.95,
                      isError: isError,
                      prefIcon: 'Assets/Key.png',
                      obscureText: true,
                    ),
                    CustomTextFormField(
                      controller: secondPasswordController,
                      keyboardType: TextInputType.phone,
                      width: width * 0.95,
                      isError: isError,
                      prefIcon: 'Assets/Key.png',
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'null';
                        if (value!.length > 1) {
                          return 'asdfsdfa';
                        }
                      },
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                                checkColor: Colors.white,
                                side: const BorderSide(width: 1),
                                value: isTap,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isTap = value!;
                                  });
                                },
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: width - 75,
                            child: Text(
                              'Jaccepte les conditions dutilisation et confirme que jaccepte la politique de confidentialité.',
                              style: AppTypography.font14black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomElevatedButton(
                      callback: () {
                        if (_formKey.currentState!.validate()) {
                          isError = true;
                          setState(() {});
                        }
                      },
                      text: 'Se faire enregistrer',
                      styleText: AppTypography.font14white,
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      child: Text('Entrée',
                          style: AppTypography.font16UnderLinePink),
                      onTap: () {
                        Navigator.pushNamed(context, '/login_first_screen');
                      },
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
