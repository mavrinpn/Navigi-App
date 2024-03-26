import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/announcement/bloc/medium_price/medium_price_cubit.dart';
import 'package:smart/feature/announcement/ui/dialogs/market_price_bottom_sheet.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/utils/app_icons_icons.dart';
import 'package:smart/utils/fonts.dart';

class MarketPriceWidget extends StatefulWidget {
  const MarketPriceWidget({
    super.key,
    required this.announcement,
  });

  final Announcement announcement;

  @override
  State<MarketPriceWidget> createState() => _MarketPriceWidgetState();
}

class _MarketPriceWidgetState extends State<MarketPriceWidget> {
  @override
  void initState() {
    super.initState();

    context
        .read<MediumPriceCubit>()
        .queryWith(parameters: widget.announcement.staticParameters.parameters);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<MediumPriceCubit, MediumPriceState>(
      builder: (context, state) {
        if (state is MediumPriceSuccessState) {
          final startPrice = state.mediumPrice * 0.9 / 10000;
          final endPrice = state.mediumPrice * 1.1 / 10000;
          final price =
              '${startPrice.toStringAsFixed(2)} - ${endPrice.toStringAsFixed(2)} MLN';

          return AnimatedContainer(
            key: const ValueKey('AnimatedContainer'),
            duration: Durations.medium1,
            height: 54,
            child: GestureDetector(
              onTap: () => showMarketPriceDialog(
                context: context,
                price: price,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 2, 5),
                child: FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(AppIcons.stat),
                      const SizedBox(width: 6),
                      Text(
                        localizations.marketPrice,
                        style: AppTypography.font14black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        price,
                        style: AppTypography.font14black.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      TextButton(
                        onPressed: () => showMarketPriceDialog(
                          context: context,
                          price: price,
                        ),
                        child: Text(
                          localizations.detail,
                          style: AppTypography.font14red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return AnimatedContainer(
            key: const ValueKey('AnimatedContainer'),
            duration: Durations.long1,
            height: 0,
          );
        }
      },
    );
  }
}
