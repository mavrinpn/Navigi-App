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
    final repository = RepositoryProvider.of<CreatingAnnouncementManager>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Text(
          'Сaractéristiques',
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
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView(
              children: (repository.currentItem != null ? repository.currentItem!.getVariableParameters() : [])
                  .map((e) => CustomDropDownSingleCheckBox(paramets: e))
                  .toList(),
            ))
          ],
        ),
      ),
      floatingActionButton: CustomElevatedButton(
        width: MediaQuery.of(context).size.width - 30,
        padding: const EdgeInsets.all(0),
        height: 52,
        text: 'Continuer',
        styleText: AppTypography.font14white,
        callback: () {
          Navigator.pushNamed(context, '/create_description');
        },
        isTouch: true,
      ),
    );
  }
}
