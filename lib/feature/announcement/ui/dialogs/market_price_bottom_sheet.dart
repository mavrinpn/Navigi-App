import 'package:flutter/material.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/app_icons_icons.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

void showMarketPriceDialog({
  required BuildContext context,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    // isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const MarketPriceBottomSheet(),
      );
    },
  );
}

class MarketPriceBottomSheet extends StatefulWidget {
  const MarketPriceBottomSheet({super.key});

  @override
  State<MarketPriceBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<MarketPriceBottomSheet> {
  final TextEditingController offerPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      // height: MediaQuery.sizeOf(context).height * 0.3,
      color: Colors.white,
      child: SafeArea(
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
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(AppIcons.stat),
                  const SizedBox(width: 6),
                  Text(
                    localizations.marketPrice,
                    style: AppTypography.font18black,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '18 000 - 21 500 DZD',
                style: AppTypography.font22black,
              ),
              const SizedBox(height: 24),
              Text(
                localizations.marketPriceCaption,
                style: AppTypography.font16black,
              ),
              const SizedBox(height: 16),
              Text(
                '  • ${localizations.markAndModel}',
                style: AppTypography.font14black,
              ),
              const SizedBox(height: 16),
              Text(
                '  • ${localizations.productParameters}',
                style: AppTypography.font14black,
              ),
              const SizedBox(height: 16),
              Text(
                '  • ${localizations.cityAndRegion}',
                style: AppTypography.font14black,
              ),
              const SizedBox(height: 24),
              CustomTextButton.orangeContinue(
                callback: () {
                  Navigator.of(context).pop();
                },
                styleText: AppTypography.font14black
                    .copyWith(fontWeight: FontWeight.bold),
                text: localizations.close,
                active: true,
                activeColor: AppColors.backgroundLightGray,
              )
            ],
          ),
        ),
      ),
    );
  }
}
