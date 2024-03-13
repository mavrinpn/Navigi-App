// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/feature/announcement/ui/dialogs/market_price_bottom_sheet.dart';
import 'package:smart/feature/announcement/ui/dialogs/offer_price_bottom_sheet.dart';
import 'package:smart/feature/announcement/ui/widgets/related_announcement_widget.dart';
import 'package:smart/feature/create_announcement/bloc/creating_blocs.dart';
import 'package:smart/feature/messenger/chat_function.dart';
import 'package:smart/main.dart';
import 'package:smart/feature/announcement/ui/photo_view.dart';
import 'package:smart/feature/announcement/ui/widgets/favourite_indicator.dart';
import 'package:smart/feature/announcement/ui/widgets/images_amount_indicators.dart';
import 'package:smart/feature/announcement/ui/widgets/parameter.dart';
import 'package:smart/feature/announcement/ui/widgets/settings_bottom_sheet.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/app_icons_icons.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../managers/announcement_manager.dart';
import '../../../utils/colors.dart';
import '../../../widgets/accuont/account_small_info.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/images/network_image.dart';
import '../bloc/announcement/announcement_cubit.dart';
import 'map.dart';

int activePage = 0;

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({
    super.key,
    required this.announcementId,
  });

  final String announcementId;

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  void initState() {
    BlocProvider.of<AnnouncementCubit>(context)
        .loadAnnouncementById(widget.announcementId);
    super.initState();
  }

  void incViewsIfNeed(AnnouncementSuccessState state) {
    final userId = RepositoryProvider.of<AuthRepository>(context).userId;
    if (userId != state.data.creatorData.uid) {
      RepositoryProvider.of<AnnouncementManager>(context)
          .incTotalViews(state.data.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    PageController pageController =
        PageController(viewportFraction: 0.9, initialPage: activePage);

    final width = MediaQuery.of(context).size.width;
    final String currentLocale = MyApp.getLocale(context) ?? 'fr';

    return BlocConsumer<AnnouncementCubit, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementSuccessState) {
          context
              .read<SubcategoryCubit>()
              .loadSubcategory(subcategoryId: state.data.subcategoryId);
        }
      },
      builder: (context, state) {
        if (state is AnnouncementSuccessState) {
          incViewsIfNeed(state);

          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AnnouncementCubit>(context)
                  .refreshAnnouncement(state.data.id);
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.empty,
                elevation: 0,
                titleSpacing: 6,
                title: Row(
                  children: [
                    const CustomBackButton(),
                    const Spacer(),
                    FavouriteIndicator(postId: state.data.id),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        if (state.data.creatorData.uid ==
                            RepositoryProvider.of<AuthRepository>(context)
                                .userId) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            showDragHandle: true,
                            builder: (ctx) {
                              return SettingsBottomSheet(
                                  announcement: state.data);
                            },
                          );
                        }
                      },
                      child: SvgPicture.asset(
                        'Assets/icons/three_dots.svg',
                        width: 24,
                        height: 24,
                        color: AppColors.black,
                      ),
                    )
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width,
                      height: 260,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PhotoViews()));
                        },
                        child: PageView.builder(
                            itemCount: state.data.images.length,
                            pageSnapping: true,
                            controller: pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                activePage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CustomNetworkImage(
                                  width: 320,
                                  height: 258,
                                  url: state.data.images[index],
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ImagesIndicators(
                      length: state.data.images.length,
                      currentIndex: activePage,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'Assets/icons/calendar.svg',
                            color: AppColors.lightGray,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            state.data.createdAt,
                            style: AppTypography.font14lightGray
                                .copyWith(fontSize: 12),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'Assets/icons/eye.svg',
                            color: AppColors.lightGray,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(state.data.totalViews.toString(),
                              style: AppTypography.font14lightGray
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      alignment: Alignment.topLeft,
                      child: Text(
                        state.data.title,
                        style: AppTypography.font18black,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 15, 18),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Aboba(
                                        placeData: state.data.placeData,
                                      )));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('Assets/icons/point.svg'),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: ' ${state.data.placeData.name}',
                                  style: AppTypography.font14black),
                            ]))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            state.data.stringPrice,
                            style: AppTypography.font22red,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                    _MarketPrice(
                      onTap: () {
                        showMarketPriceDialog(context: context);
                      },
                    ),
                    Row(
                      children: [
                        CustomTextButton.withIcon(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          disableColor: AppColors.red,
                          width: MediaQuery.of(context).size.width - 62,
                          callback: () {
                            checkBlockedAndPushChat(
                              context: context,
                              data: state.data,
                            );
                          },
                          text: AppLocalizations.of(context)!.toWrite,
                          styleText: AppTypography.font14white,
                          icon: SvgPicture.asset(
                            'Assets/icons/email.svg',
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        CustomIconButton(
                          callback: () {
                            checkBlockedAndCall(
                              context: context,
                              userId: state.data.creatorData.uid,
                              phone: state.data.creatorData.phone,
                            );
                          },
                          icon: 'Assets/icons/phone.svg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextButton.withIcon(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      callback: () {
                        showOfferPriceDialog(
                          context: context,
                          announcementId: state.data.id,
                        ).then((offerPrice) {
                          if (offerPrice != null) {
                            checkBlockedAndPushChat(
                              context: context,
                              data: state.data,
                              message:
                                  '${localizations.offerMessage} ${offerPrice.round()}',
                            );
                          }
                        });
                      },
                      text: AppLocalizations.of(context)!.offrirVotrePrix,
                      styleText: AppTypography.font14black,
                      icon: SvgPicture.asset('Assets/icons/dzd.svg'),
                      disableColor: AppColors.backgroundLightGray,
                    ),
                    const SizedBox(height: 26),
                    BlocBuilder<SubcategoryCubit, SubcategoryState>(
                        builder: (context, state) {
                      if (state is SubcategorySuccessState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            '${state.category.nameFr} / ${state.subcategory.nameFr}',
                            textAlign: TextAlign.start,
                            style: AppTypography.font16black
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.features,
                            style: AppTypography.font16black
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...state.data.staticParameters.parameters
                        .map((e) => ItemParameterWidget(
                            name: currentLocale == 'fr' ? e.nameFr : e.nameAr,
                            currentValue:
                                currentLocale == 'fr' ? e.valueFr : e.valueAr))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: AppTypography.font16black
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width - 30,
                      child: Text(
                        state.data.description,
                        style: AppTypography.font14black.copyWith(height: 2),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AccountSmallInfo(
                      creatorData: state.data.creatorData,
                      clickable: true,
                    ),
                    RelatedAnnouncementWidget(
                      price: state.data.price,
                      subcategoryId: state.data.subcategoryId,
                      parentId: state.data.id,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: AppAnimations.circleFadingAnimation,
            ),
          );
        }
      },
    );
  }
}

class _MarketPrice extends StatelessWidget {
  const _MarketPrice({
    required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
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
                '18 000 - 21 500 DZD',
                style: AppTypography.font14black.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              TextButton(
                onPressed: onTap,
                child: Text(
                  localizations.detail,
                  style: AppTypography.font14red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
