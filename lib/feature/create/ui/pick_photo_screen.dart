import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/feature/create/bloc/item_search/item_search_cubit.dart';
import 'package:smart/feature/create/data/creting_announcement_manager.dart';
import 'package:smart/widgets/button/custom_eleveted_button.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/category/products.dart';
import '../../../widgets/textField/outline_text_field.dart';

class PickPhotosScreen extends StatefulWidget {
  const PickPhotosScreen({super.key});

  @override
  State<PickPhotosScreen> createState() => _PickPhotosScreenState();
}

class _PickPhotosScreenState extends State<PickPhotosScreen> {
  bool photosSelected = false;
  ImagePicker picker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    final repository =
        RepositoryProvider.of<CreatingAnnouncementManager>(context);

    Future pickImages() async {
      images = await picker.pickMultiImage();
      log(images.length.toString());
    }

    Future addImages() async {
      final imgs = await picker.pickMultiImage();
      images.addAll(imgs);
      setState(() {});
    }

    void select() async {
      pickImages().then((value) => {
            setState(() {
              photosSelected = true;
              log('setState ${images.length}');
            })
          });
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
              !photosSelected
                  ? CustomElevatedButton(
                      isTouch: true,
                      activeColor: AppColors.isTouchButtonColorDark,
                      padding: EdgeInsets.zero,
                      height: 52,
                      callback: () {
                        select();
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
                        physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
                        itemCount: images.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 113,
                                mainAxisSpacing: 7,
                                crossAxisSpacing: 7,
                                crossAxisCount: 3),
                        itemBuilder: (_, int index) {
                          if (index != images.length) {
                            return ImageWidget(path: images[index].path);
                          } else {
                            return AddImageWidget(callback: addImages,);
                          }
                        },
                      ),
                    ),
              const SizedBox(height: 80,)
            ],
          ),
        ),
        floatingActionButton: photosSelected
            ? CustomElevatedButton(
                isTouch: true,
                width: MediaQuery.of(context).size.width - 30,
                padding: const EdgeInsets.all(0),
                height: 52,
                text: 'Continuer',
                styleText: AppTypography.font14white,
                callback: () {
                  setState(() {
                    repository.setImages(images);
                  });
                })
            : Container());
  }
}

class ImageWidget extends StatelessWidget {
  ImageWidget({super.key, required this.path});

  final String path;

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
            alignment: Alignment.topRight,
            child: SvgPicture.asset('Assets/icons/delete_button.svg', width: 24,)
          ),
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
