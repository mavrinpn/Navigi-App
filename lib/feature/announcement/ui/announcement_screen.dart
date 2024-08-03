// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/bloc/app/app_cubit.dart';
import 'package:smart/feature/announcement/ui/dialogs/creator_show_more_bottom_sheet.dart';
import 'package:smart/feature/announcement/ui/dialogs/offer_price_bottom_sheet.dart';
import 'package:smart/feature/announcement/ui/widgets/announcement_mini_map.dart';
import 'package:smart/feature/announcement/ui/widgets/market_price_widget.dart';
import 'package:smart/feature/announcement/ui/widgets/related_announcement_widget.dart';
import 'package:smart/feature/create_announcement/bloc/creating_blocs.dart';
import 'package:smart/feature/create_announcement/bloc/mark_model/mark_model_cubit.dart';
import 'package:smart/feature/messenger/chat_function.dart';
import 'package:smart/main.dart';
import 'package:smart/feature/announcement/ui/photo_view.dart';
import 'package:smart/feature/announcement/ui/widgets/favourite_indicator.dart';
import 'package:smart/feature/announcement/ui/widgets/images_amount_indicators.dart';
import 'package:smart/feature/announcement/ui/widgets/parameter.dart';
import 'package:smart/feature/announcement/ui/widgets/additional_menu_bottom_sheet.dart';
import 'package:smart/feature/auth/data/auth_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/item/static_localized_parameter.dart';
import 'package:smart/utils/animations.dart';
import 'package:smart/utils/constants.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/utils/routes/route_names.dart';
import 'package:smart/widgets/button/back_button.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../managers/announcement_manager.dart';
import '../../../utils/colors.dart';
import '../../../widgets/accuont/account_small_info.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../bloc/announcement/announcement_cubit.dart';
import 'map.dart';

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
  int activePage = 0;

  @override
  void initState() {
    BlocProvider.of<AnnouncementCubit>(context).loadAnnouncementById(widget.announcementId);
    super.initState();
  }

  void incViewsIfNeed(AnnouncementSuccessState state) {
    final userId = RepositoryProvider.of<AuthRepository>(context).userId;
    if (userId != state.data.creatorData.uid) {
      RepositoryProvider.of<AnnouncementManager>(context).incTotalViews(state.data.anouncesTableId);
    }
  }

  void incContactsIfNeed(AnnouncementSuccessState state) {
    final userId = RepositoryProvider.of<AuthRepository>(context).userId;
    if (userId != state.data.creatorData.uid) {
      RepositoryProvider.of<AnnouncementManager>(context).incContactsViews(state.data.anouncesTableId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    PageController pageController = PageController(viewportFraction: 0.9, initialPage: activePage);

    const maxImageCount = 10;

    return BlocConsumer<AnnouncementCubit, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementSuccessState) {
          context.read<SubcategoryCubit>().loadSubcategory(subcategoryId: state.data.subcategoryId);
          context.read<MarkModelCubit>().load(
                markId: state.data.mark,
                modelId: state.data.model,
              );
        }
      },
      builder: (context, state) {
        if (state is AnnouncementSuccessState) {
          final isUserAuth = context.read<AppCubit>().state is AppAuthState;
          if (isUserAuth) {
            incViewsIfNeed(state);
          }

          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AnnouncementCubit>(context).refreshAnnouncement(state.data.anouncesTableId);
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.appBarColor,
                elevation: 0,
                titleSpacing: 6,
                title: Row(
                  children: [
                    const CustomBackButton(),
                    const Spacer(),
                    FavouriteIndicator(postId: state.data.anouncesTableId),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                        if (!isUserAuth) {
                          Navigator.of(context).pushNamed(
                            AppRoutesNames.loginFirst,
                            arguments: {'showBackButton': true},
                          );
                          return;
                        }
                        if (state.data.creatorData.uid == RepositoryProvider.of<AuthRepository>(context).userId) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            showDragHandle: true,
                            builder: (ctx) {
                              return AdditionalMenuBottomSheet(announcement: state.data);
                            },
                          );
                        } else {
                          creatorShowMoreAction(
                            context: context,
                            userId: state.data.creatorData.uid,
                            onAction: (value) {},
                          );
                        }
                      },
                      icon: SvgPicture.asset('Assets/icons/menu_dots_vertical.svg'),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // width: width,
                      height: 260,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<int>(
                              builder: (_) => PhotoViews(
                                images: state.data.images.take(maxImageCount).toList(),
                                activePage: activePage,
                                onPageChanged: (value) {
                                  activePage = value;
                                },
                              ),
                            ),
                          ).then((_) {
                            pageController.animateToPage(
                              activePage,
                              duration: Durations.medium2,
                              curve: Curves.bounceInOut,
                            );
                          });
                        },
                        child: PageView.builder(
                            clipBehavior: Clip.none,
                            itemCount: min(state.data.images.length, maxImageCount),
                            pageSnapping: true,
                            controller: pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                activePage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: activePage == 0 ? 12 : 6,
                                  left: activePage == 0 ? 0 : 6,
                                ),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          state.data.images[index],
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 25,
                                        sigmaY: 25,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: state.data.images[index],
                                        fit: BoxFit.contain,
                                        fadeInDuration: Duration.zero,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ImagesIndicators(
                      length: min(state.data.images.length, maxImageCount),
                      currentIndex: activePage,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                            style: AppTypography.font14lightGray.copyWith(fontSize: 12),
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
                              style: AppTypography.font14lightGray.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                              builder: (_) => MapScreen(
                                placeData: state.data.area,
                                latitude: state.data.latitude,
                                longitude: state.data.longitude,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('Assets/icons/point.svg'),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(text: ' ${state.data.area.name}', style: AppTypography.font14black),
                            ]))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                    if (state.data.subcategoryId == carSubcategoryId)
                      MarketPriceWidget(
                        announcement: state.data,
                      ),
                    Row(
                      children: [
                        CustomTextButton.withIcon(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          disableColor: AppColors.red,
                          width: MediaQuery.of(context).size.width - 62,
                          callback: () {
                            final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                            if (!isUserAuth) {
                              Navigator.of(context).pushNamed(
                                AppRoutesNames.loginFirst,
                                arguments: {'showBackButton': true},
                              );
                              return;
                            }
                            incContactsIfNeed(state);
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
                            final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                            if (!isUserAuth) {
                              Navigator.of(context).pushNamed(
                                AppRoutesNames.loginFirst,
                                arguments: {'showBackButton': true},
                              );
                              return;
                            }
                            incContactsIfNeed(state);
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
                        final isUserAuth = context.read<AppCubit>().state is AppAuthState;
                        if (!isUserAuth) {
                          Navigator.of(context).pushNamed(
                            AppRoutesNames.loginFirst,
                            arguments: {'showBackButton': true},
                          );
                          return;
                        }
                        showOfferPriceDialog(
                          context: context,
                          announcement: state.data,
                        ).then((offerPriceString) {
                          if (offerPriceString != null) {
                            incContactsIfNeed(state);
                            checkBlockedAndPushChat(
                              context: context,
                              data: state.data,
                              message: '${localizations.offerMessage} $offerPriceString',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.features,
                            style: AppTypography.font16black.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _categoryWidget(),
                    _markModelWidget(),
                    ..._staticParameters(state.data.staticParameters.parameters),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.description,
                            style: AppTypography.font16black.copyWith(fontWeight: FontWeight.w700),
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
                    if (state.data.creatorData.uid != RepositoryProvider.of<AuthRepository>(context).userId)
                      AccountSmallInfo(
                        creatorData: state.data.creatorData,
                        clickable: true,
                      ),
                    AnnouncementMiniMap(
                      cityDistrict: state.data.area,
                      latitude: state.data.latitude,
                      longitude: state.data.longitude,
                    ),
                    RelatedAnnouncementWidget(
                      price: state.data.price,
                      subcategoryId: state.data.subcategoryId,
                      parentId: state.data.anouncesTableId,
                      model: state.data.model,
                      staticParameters: state.data.staticParameters,
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

  BlocBuilder<MarkModelCubit, MarkModelState> _markModelWidget() {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<MarkModelCubit, MarkModelState>(
      builder: (context, state) {
        if (state is MarkModelSuccessState) {
          return Column(
            children: [
              if (state.markName != null)
                ItemParameterWidget(
                  name: localizations.mark,
                  currentValue: state.markName!,
                ),
              if (state.modelName != null)
                ItemParameterWidget(
                  name: localizations.model,
                  currentValue: state.modelName!,
                ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[700]!,
            highlightColor: Colors.grey[300]!,
            child: Column(
              children: [
                ItemParameterWidget(
                  name: localizations.mark,
                  currentValue: '',
                ),
                ItemParameterWidget(
                  name: localizations.model,
                  currentValue: '',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  BlocBuilder<SubcategoryCubit, SubcategoryState> _categoryWidget() {
    final localizations = AppLocalizations.of(context)!;
    final String currentLocale = MyApp.getLocale(context) ?? 'fr';

    return BlocBuilder<SubcategoryCubit, SubcategoryState>(
      builder: (context, state) {
        if (state is SubcategorySuccessState) {
          return Column(
            children: [
              ItemParameterWidget(
                name: localizations.category,
                currentValue: currentLocale == 'fr' ? state.category.nameFr : state.category.nameAr,
              ),
              ItemParameterWidget(
                name: localizations.subcategory,
                currentValue: currentLocale == 'fr' ? state.subcategory.nameFr : state.subcategory.nameAr,
              ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[700]!,
            highlightColor: Colors.grey[300]!,
            child: Column(
              children: [
                ItemParameterWidget(
                  name: localizations.category,
                  currentValue: '',
                ),
                ItemParameterWidget(
                  name: localizations.subcategory,
                  currentValue: '',
                ),
              ],
            ),
          );
        }
      },
    );
  }

  List<Widget> _staticParameters(List<StaticLocalizedParameter> parameters) {
    List<Widget> result = [];

    for (final param in parameters) {
      if (param.runtimeType != MultiSelectStaticParameter) {
        result.add(
          ItemParameterWidget(
            name: currentLocaleShortName.value == 'fr' ? param.nameFr : param.nameAr,
            currentValue: currentLocaleShortName.value == 'fr' ? param.valueFr : param.valueAr,
          ),
        );
      }
    }
    for (final param in parameters) {
      if (param.runtimeType == MultiSelectStaticParameter) {
        result.add(
          ItemParameterWidget(
            name: currentLocaleShortName.value == 'fr' ? param.nameFr : param.nameAr,
            currentValue: currentLocaleShortName.value == 'fr' ? param.valueFr : param.valueAr,
          ),
        );
      }
    }

    return result;
  }
}
