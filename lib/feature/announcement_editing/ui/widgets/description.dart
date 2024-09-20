import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection(
      {super.key,
      required this.localizations,
      required this.descriptionController,
      required this.onChange});

  final AppLocalizations localizations;
  final TextEditingController descriptionController;
  final Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            localizations.description,
            style: AppTypography.font16black.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 5),
        OutlineTextField(
          keyBoardType: TextInputType.multiline,
          hintText: localizations.description,
          controller: descriptionController,
          maxLines: 20,
          height: 310,
          width: double.infinity,
          maxLength: 500,
          onChange: onChange,
        )
      ],
    );
  }
}
