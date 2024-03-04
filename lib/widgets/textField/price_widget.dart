import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.maxPriseController,
    required this.minPriseController,
  });

  final TextEditingController minPriseController;
  final TextEditingController maxPriseController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Column(children: [
          Row(children: [
            SvgPicture.asset(
              'Assets/icons/dzd.svg',
              width: 24,
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.price,
                style: AppTypography.font18gray)
          ]),
          const SizedBox(
            height: 14,
          ),
          Row(children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 24,
                child: UnderLineTextField(
                  width: MediaQuery.of(context).size.width * 0.4,
                  hintText: '',
                  keyBoardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  suffixIcon: 'DZD',
                  controller: minPriseController,
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
                      style: AppTypography.font18gray.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w400))),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                  height: 24,
                  child: UnderLineTextField(
                    width: MediaQuery.of(context).size.width * 0.4,
                    hintText: '',
                    keyBoardType: TextInputType.number,
                    suffixIcon: 'DZD',
                    controller: maxPriseController,
                    onChange: (String value) {},
                  )),
            )
          ]),
        ]),
      ),
    );
  }
}
