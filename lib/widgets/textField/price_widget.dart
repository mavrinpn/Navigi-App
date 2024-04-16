import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/price_type.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({
    super.key,
    required this.maxPriceController,
    required this.minPriceController,
    required this.onChangePriceType,
    required this.priceType,
    required this.subcategoryId,
  });

  final Function(PriceType) onChangePriceType;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final PriceType priceType;
  final String subcategoryId;

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget> {
  late final List<PriceType> _availableTypes;
  late PriceType _priceType;

  @override
  void didUpdateWidget(PriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _priceType = widget.priceType;
  }

  @override
  void initState() {
    super.initState();
    _availableTypes = PriceTypeExtendion.availableTypesFor(widget.subcategoryId);
    if (_availableTypes.contains(widget.priceType)) {
      _priceType = widget.priceType;
    } else {
      _priceType = _availableTypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Column(
          children: [
            Row(children: [
              SvgPicture.asset(
                'Assets/icons/dzd.svg',
                width: 24,
              ),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.price, style: AppTypography.font18gray)
            ]),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 24,
                    child: UnderLineTextField(
                      width: MediaQuery.of(context).size.width * 0.4,
                      hintText: '',
                      keyBoardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      priceType: _priceType,
                      availableTypes: _availableTypes,
                      onChangePriceType: (priceType) {
                        widget.onChangePriceType(priceType);
                      },
                      controller: widget.minPriceController,
                      onChange: (String value) {},
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                      width: 17,
                      child: Text('—',
                          textAlign: TextAlign.center,
                          style: AppTypography.font18gray.copyWith(fontSize: 16, fontWeight: FontWeight.w400))),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 24,
                    child: UnderLineTextField(
                      width: MediaQuery.of(context).size.width * 0.4,
                      hintText: '',
                      keyBoardType: TextInputType.number,
                      priceType: _priceType,
                      availableTypes: _availableTypes,
                      onChangePriceType: (priceType) {
                        widget.onChangePriceType(priceType);
                      },
                      controller: widget.maxPriceController,
                      onChange: (String value) {},
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
