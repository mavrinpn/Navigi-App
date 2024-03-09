import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/utils/routes/route_names.dart';

import '../../../managers/creating_announcement_manager.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/button/custom_text_button.dart';
import 'widgets/add_image.dart';
import 'widgets/image.dart';

class PickPhotosScreen extends StatefulWidget {
  const PickPhotosScreen({super.key});

  @override
  State<PickPhotosScreen> createState() => _PickPhotosScreenState();
}

class _PickPhotosScreenState extends State<PickPhotosScreen> {
  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    final localizations = AppLocalizations.of(context)!;

    Future addImages() async {
      await repository.pickImages();
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            localizations.photo,
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26),
              Text(
                  'Pharetra ultricies ullamcorper a et magna convallis condimentum. Proin mi orci dignissim lectus nulla neque',
                  style: AppTypography.font14lightGray),
              const SizedBox(
                height: 26,
              ),
              !repository.images.isNotEmpty
                  ? CustomTextButton.withIcon(
                      active: true,
                      activeColor: AppColors.dark,
                      callback: () {
                        addImages();
                      },
                      text: localizations.addPictures,
                      styleText: AppTypography.font14white,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : Expanded(
                      //height: MediaQuery.of(context).size.height - 320,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast),
                        itemCount: repository.images.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 113,
                                mainAxisSpacing: 7,
                                crossAxisSpacing: 7,
                                crossAxisCount: 3),
                        itemBuilder: (_, int index) {
                          if (index != repository.images.length) {
                            return ImageWidget(
                              path: repository.images[index].path,
                              callback: () {
                                repository.images.removeAt(index);
                                setState(() {});
                              },
                            );
                          } else {
                            return AddImageWidget(callback: addImages);
                          }
                        },
                      ),
                    ),
              const SizedBox(height: 80)
            ],
          ),
        ),
        floatingActionButton: repository.images.isNotEmpty
            ? CustomTextButton.orangeContinue(
                active: true,
                width: MediaQuery.of(context).size.width - 30,
                text: localizations.continue_,
                callback: () {
                  setState(() {
                    repository.setImages(repository.images);
                    Navigator.pushNamed(
                        context, AppRoutesNames.announcementCreatingType);
                  });
                })
            : Container());
  }
}
