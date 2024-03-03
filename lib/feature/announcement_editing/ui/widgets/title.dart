import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/textField/outline_text_field.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.localizations, required this.titleController, required this.onChange});

  final AppLocalizations localizations;
  final TextEditingController titleController;
  final Function(String?) onChange;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              localizations.title,
              style: AppTypography.font16black.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 5),
          OutlineTextField(
            hintText: localizations.name,
            controller: titleController,
            maxLines: 5,
            height: 100,
            width: double.infinity,
            maxLength: 100,
            onChange: onChange,
          ),
        ],
      ),
    );
  }
}
