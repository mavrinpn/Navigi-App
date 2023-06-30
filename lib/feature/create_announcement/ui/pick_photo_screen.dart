import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/widgets/button/custom_eleveted_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../data/creting_announcement_manager.dart';

class PickPhotosScreen extends StatefulWidget {
  const PickPhotosScreen({super.key});

  @override
  State<PickPhotosScreen> createState() => _PickPhotosScreenState();
}

class _PickPhotosScreenState extends State<PickPhotosScreen> {
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    Future pickImages() async {
      repository.images = await picker.pickMultiImage();
      setState(() {});
    }

    Future addImages() async {
      final imgs = await picker.pickMultiImage();
      repository.images.addAll(imgs);
      setState(() {});
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData.fallback(),
          backgroundColor: AppColors.empty,
          elevation: 0,
          title: Text(
            'Photo',
            style: AppTypography.font20black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 26,
              ),
              Text(
                  'Pharetra ultricies ullamcorper a et magna convallis condimentum. Proin mi orci dignissim lectus nulla neque',
                  style: AppTypography.font14lightGray),
              const SizedBox(
                height: 26,
              ),
              !repository.images.isNotEmpty
                  ? CustomElevatedButton(
                      isTouch: true,
                      activeColor: AppColors.isTouchButtonColorDark,
                      padding: EdgeInsets.zero,
                      height: 52,
                      callback: () {
                        pickImages();
                      },
                      text: '',
                      styleText: AppTypography.font14white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Ajouter des photos',
                            style: AppTypography.font14white,
                          )
                        ],
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
                            return AddImageWidget(
                              callback: addImages,
                            );
                          }
                        },
                      ),
                    ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
        floatingActionButton: repository.images.isNotEmpty
            ? CustomElevatedButton.orangeContinue(
                isTouch: true,
                width: MediaQuery.of(context).size.width - 30,
                text: 'Continuer',
                callback: () {
                  setState(() {
                    repository.setImages(repository.images);
                    Navigator.pushNamed(context, '/create_by_not_by_screen');
                  });
                })
            : Container());
  }
}

class ImageWidget extends StatelessWidget {
  ImageWidget({super.key, required this.path, required this.callback});

  final String path;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113,
      height: 106,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 105,
              height: 98,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.red,
                  image: DecorationImage(
                      image: FileImage(File(path)), fit: BoxFit.cover)),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 6),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: callback,
                child: SvgPicture.asset(
                  'Assets/icons/delete_button.svg',
                  width: 27,
                ),
              )),
        ],
      ),
    );
  }
}

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 105,
        height: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.backgroundLightGray,
        ),
        child: Center(
          child: SvgPicture.asset(
            'Assets/icons/add_image.svg',
            width: 32,
          ),
        ),
      ),
    );
  }
}
