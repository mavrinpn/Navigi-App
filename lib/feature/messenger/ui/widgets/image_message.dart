import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/widgets/button/back_button.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.imageUrl,
    required this.isCurrentUser,
  });

  final String imageUrl;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              title: const Row(
                children: [
                  CustomBackButton(
                    color: Colors.white,
                  )
                ],
              ),
            ),
            body: PhotoScreen(
              image: NetworkImage(imageUrl),
            ),
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: !isCurrentUser ? AppColors.backgroundLightGray : AppColors.red,
            borderRadius: BorderRadius.circular(16)
          ),
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.all(2),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14)
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: image,
                initialScale: PhotoViewComputedScale.contained,
              );
            }),
      ),
    );
  }
}
