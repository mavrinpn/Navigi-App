import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

class PriceSection extends StatelessWidget {
  const PriceSection(
      {super.key,
      required this.localizations,
      required this.priceController,
      required this.priceValidator,
      required this.savePrice,
      required this.onChange});

  final AppLocalizations localizations;
  final TextEditingController priceController;
  final String? Function(String?) priceValidator;
  final VoidCallback savePrice;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.price,
            style: AppTypography.font18black,
          ),
          UnderLineTextField(
            width: double.infinity,
            hintText: '',
            controller: priceController,
            keyBoardType: TextInputType.number,
            validator: priceValidator,
            onChange: onChange,
            onEditingComplete: savePrice,
            onTapOutside: (e) {
              savePrice();
            },
            suffixIcon: 'DZD',
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
