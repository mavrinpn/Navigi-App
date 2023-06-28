import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import '../../../models/variable_paramets.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_eleveted_button.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/dropDownSingleCheckBox/custon_dropDown_single_checkbox.dart';
import '../../../widgets/textField/outline_text_field.dart';
import '../../../widgets/textField/under_line_text_field.dart';

List<VariableParameters> list = [
  VariableParameters(key: 'sdf', variants: ['asdf', 'asfa', 'asf']),
  VariableParameters(key: 'sdf', variants: ['asdf', 'asfa', 'asf']),
  VariableParameters(key: 'sdf', variants: ['asdf', 'asfa', 'asf']),
  VariableParameters(key: 'sdf', variants: ['asdf', 'asfa', 'asf']),
];

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final productsController = TextEditingController();

  final priseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Indiquez le nom',
          style: AppTypography.font20black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              'Prix',
              style: AppTypography.font16black.copyWith(fontSize: 18),
            ),
            UnderLineTextField(
              width: double.infinity,
              hintText: '',
              controller: priseController,
              onChange: (String value) {},
              suffixIcon: 'DZD',
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView(
              children: list
                  .map((e) => CustomDropDownSingleCheckBox(paramets: e))
                  .toList(),
            ))
          ],
        ),
      ),
    );
  }
}
