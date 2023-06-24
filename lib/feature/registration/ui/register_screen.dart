import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart/utils/fonts.dart';

import '../../../utils/colors.dart';
import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/textField/custom_text_field.dart';
import '../../../widgets/textField/mask_text_field.dart';

final maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+## (###) ###-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

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

  bool isTouch = false;
  bool isTapCheckBox = false;

  bool checkFields(String phone, String name, String firstPassword,
      String secondPassword) {
    return phone.length == 11 &&
        name.isNotEmpty &&
        firstPassword == secondPassword &&
        firstPassword.length >= 8 &&
        isTapCheckBox;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    void checkIsTouch() {
      if (checkFields(maskPhoneFormatter.getUnmaskedText(), nameController.text,
          firstPasswordController.text, secondPasswordController.text)) {
        isTouch = true;
        setState(() {});
        return;
      }
      isTouch = false;
      setState(() {});
    }

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
                        prefIcon: 'Assets/People.png',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Erreur! Réessayez ou entrez dautres informations.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          checkIsTouch();
                        }
                    ),
                    MaskTextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      width: width * 0.95,
                      prefIcon: 'Assets/Phone.png',
                      validator: (value) {
                        if (maskPhoneFormatter
                            .getUnmaskedText()
                            .length != 11) {
                          return 'Erreur! Réessayez ou entrez dautres informations.';
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
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        prefIcon: 'Assets/Key.png',
                        obscureText: true,
                        validator: (value) {
                          if (value! != secondPasswordController.text ||
                              value.length < 8) {
                            return 'Erreur! Réessayez ou entrez dautres informations.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          checkIsTouch();
                        }
                    ),
                    CustomTextFormField(
                        controller: secondPasswordController,
                        keyboardType: TextInputType.phone,
                        width: width * 0.95,
                        prefIcon: 'Assets/Key.png',
                        obscureText: true,
                        validator: (value) {
                          if (value! != firstPasswordController.text ||
                              value.length < 8) {
                            return 'Erreur! Réessayez ou entrez dautres informations.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          checkIsTouch();
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              side: const BorderSide(width: 1),
                              value: isTapCheckBox,
                              onChanged: (bool? value) {
                                setState(() {
                                  isTapCheckBox = !isTapCheckBox!;
                                });

                                if (checkFields(
                                    maskPhoneFormatter.getUnmaskedText(),
                                    nameController.text,
                                    firstPasswordController.text,
                                    secondPasswordController.text)) {
                                  isTouch = true;
                                  setState(() {});
                                  return;
                                }
                                isTouch = false;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
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
                          setState(() {});
                        }
                        Navigator.pushNamed(context, '/home_screen');
                      },
                      text: 'Se faire enregistrer',
                      styleText: AppTypography.font14white,
                      height: 52,
                      isTouch: isTouch,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      activeColor: AppColors.isTouchButtonColorDark,
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
