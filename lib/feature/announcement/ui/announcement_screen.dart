import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

import '../../../models/item.dart';
import '../../../utils/colors.dart';
import '../../../widgets/button/custom_icon_button.dart';

List<String> photos = [
  'Assets/defaul.png',
  'Assets/logo.png',
  'Assets/Mask.png'
];

List<VariableParameter> parameters = [
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
  VariableParameter(key: 'asdf', variants: ['asdf']),
];

int activePage = 0;

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    PageController _pageController =
        PageController(viewportFraction: 0.9, initialPage: activePage);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.empty,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.black,
              ),
            ),
            Row(
              children: [
                InkWell(
                  focusColor: AppColors.empty,
                  hoverColor: AppColors.empty,
                  highlightColor: AppColors.empty,
                  splashColor: AppColors.empty,
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: SvgPicture.asset(
                    'Assets/icons/follow.svg',
                    width: 24,
                    height: 24,
                    color: isLiked ? AppColors.red : AppColors.whiteGray,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                InkWell(
                  focusColor: AppColors.empty,
                  hoverColor: AppColors.empty,
                  highlightColor: AppColors.empty,
                  splashColor: AppColors.empty,
                  onTap: () {},
                  child: SvgPicture.asset(
                    'Assets/icons/three_dots.svg',
                    width: 24,
                    height: 24,
                    color: AppColors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: SizedBox(
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: width,
                height: 260,
                child: InkWell(
                  focusColor: AppColors.empty,
                  hoverColor: AppColors.empty,
                  highlightColor: AppColors.empty,
                  splashColor: AppColors.empty,
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const PhotoViews()));
                  },
                  child: PageView.builder(
                      itemCount: photos.length,
                      pageSnapping: true,
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(photos[index]),
                                  fit: BoxFit.cover)),
                        );
                      }),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicators(photos.length, activePage),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/calendar.svg',
                          color: AppColors.lightGray,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Aujourdhui à 18:25',
                          style: AppTypography.font14lightGray
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'Assets/icons/eye.svg',
                          color: AppColors.lightGray,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text('13 vues',
                            style: AppTypography.font14lightGray
                                .copyWith(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Text(
                  'Planchette Apple iPad Pro 12.9" (2020) Wi-Fi 256GB Space Grey (MXAT2RU/A)',
                  style: AppTypography.font18black,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '18 500 DZD',
                      style: AppTypography.font22red,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CustomTextButton.withIcon(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    disableColor: AppColors.red,
                    width: MediaQuery.of(context).size.width - 62,
                    callback: () {},
                    text: 'Écrire',
                    styleText: AppTypography.font14white,
                    icon: SvgPicture.asset(
                      'Assets/icons/email.svg',
                      color: Colors.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  CustomIconButton(
                    callback: () {},
                    icon: 'Assets/icons/phone.svg',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextButton.withIcon(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                callback: () {},
                text: 'Offrir votre prix',
                styleText: AppTypography.font14black,
                icon: SvgPicture.asset('Assets/icons/dzd.svg'),
                disableColor: AppColors.backgroundLightGray,
              ),
              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'Caractéristiques',
                      style: AppTypography.font18black.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                child: Column(
                  children: parameters
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.key,
                                  style: AppTypography.font14lightGray,
                                ),
                                Text(
                                  e.currentValue,
                                  style: AppTypography.font14black
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: AppTypography.font16black
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: Text(
                  'Lacus consectetur viverra condimentum sit mattis hendrerit. Nunc aliquet dui ipsum in. Laoreet vestibulum nunc vulputate mauris tempus amet nec neque dui. Augue nulla venenatis ut vitae sapien nullam. Diam scelerisque nibh et fusce mauris nunc semper felis. Fames sem sed duis senectus ac nascetur ultrices auctor. Tincidunt sagittis sagittis in commodo elementum nec ut. Purus in viverra consequat augue vestibulum viverra.',
                  style: AppTypography.font14black.copyWith(height: 2),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
          color: currentIndex == index ? AppColors.red : AppColors.lightGray,
          shape: BoxShape.circle),
    );
  });
}

class PhotoViews extends StatefulWidget {
  const PhotoViews({super.key});

  @override
  State<PhotoViews> createState() => _PhotoViewsState();
}

class _PhotoViewsState extends State<PhotoViews> {
  @override
  Widget build(BuildContext context) {
    PageController _pageController =
        PageController(initialPage: activePage);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const AnnouncementScreen()));
                },
                child: const Icon(Icons.arrow_back))
          ],
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(photos[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
          );
        },
        onPageChanged: (int page) {
          setState(() {
            activePage = page;
            print(activePage);
          });
        },
        itemCount: photos.length,
        loadingBuilder: (context, event) => const Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
        pageController: _pageController,
      ),
    );
  }
}
