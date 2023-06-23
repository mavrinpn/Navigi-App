import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../../widgets/textField/phone_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final phoneController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  'Lorem lobortis mi ornare nisi tellus sed aliquam accuornare nis',
                  style: AppTypography.font14lightGray,
                  textAlign: TextAlign.center,
                ),
              ),
              PhoneTextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
