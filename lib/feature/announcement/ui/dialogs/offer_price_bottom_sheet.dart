import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';
import 'package:smart/widgets/textField/under_line_text_field.dart';

Future<double?> showOfferPriceDialog({
  required BuildContext context,
  required String announcementId,
}) {
  return showModalBottomSheet<double>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const OfferPriceBottomSheet(),
      );
    },
  );
}

class OfferPriceBottomSheet extends StatefulWidget {
  const OfferPriceBottomSheet({super.key});

  @override
  State<OfferPriceBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<OfferPriceBottomSheet> {
  final TextEditingController offerPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: ShapeDecoration(
                        color: const Color(0xFFDDE1E7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1))),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.price,
                  style: AppTypography.font20black,
                ),
                const SizedBox(height: 16),
                UnderLineTextField(
                  width: MediaQuery.of(context).size.width * 1,
                  hintText: '',
                  keyBoardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  suffixIcon: 'DZD',
                  controller: offerPriceController,
                  onChange: (String value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                CustomTextButton.orangeContinue(
                  callback: () {
                    return Navigator.of(context)
                        .pop(double.tryParse(offerPriceController.text));
                  },
                  text: localizations.send,
                  active: double.tryParse(offerPriceController.text) != null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
