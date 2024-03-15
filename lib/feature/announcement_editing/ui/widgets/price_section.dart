import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

class PriceSection extends StatefulWidget {
  const PriceSection({
    super.key,
    required this.localizations,
    required this.priceController,
    required this.priceValidator,
    required this.savePrice,
    required this.onChange,
    required this.onChangePriceType,
    required this.priceType,
  });

  final Function(PriceType) onChangePriceType;
  final PriceType priceType;
  final AppLocalizations localizations;
  final TextEditingController priceController;
  final String? Function(String?) priceValidator;
  final VoidCallback savePrice;
  final Function(String) onChange;

  @override
  State<PriceSection> createState() => _PriceSectionState();
}

class _PriceSectionState extends State<PriceSection> {
  PriceType _priceType = PriceType.dzd;

  @override
  void initState() {
    super.initState();
    _priceType = widget.priceType;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.localizations.price,
            style: AppTypography.font18black,
          ),
          UnderLineTextField(
            width: double.infinity,
            hintText: '',
            controller: widget.priceController,
            keyBoardType: TextInputType.number,
            validator: widget.priceValidator,
            onChange: widget.onChange,
            onEditingComplete: widget.savePrice,
            onTapOutside: (e) {
              widget.savePrice();
            },
            priceType: _priceType,
            onChangePriceType: (priceType) {
              setState(() {
                _priceType = priceType;
              });
              widget.onChangePriceType(_priceType);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
