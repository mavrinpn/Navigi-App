import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/widgets/images_amount_indicators.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/widgets/button/back_button.dart';

class PhotoViews extends StatefulWidget {
  const PhotoViews({
    required this.images,
    super.key,
  });

  final List images;

  @override
  State<PhotoViews> createState() => _PhotoViewsState();
}

class _PhotoViewsState extends State<PhotoViews> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: activePage);

    // final currentAnnouncement =
    //     RepositoryProvider.of<AnnouncementManager>(context).lastAnnouncement;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(color: Colors.white),
        // title: Row(
        //   children: [
        //     InkWell(
        //         onTap: () {
        //           Navigator.pushReplacementNamed(
        //             context,
        //             AppRoutesNames.announcement,
        //             arguments: currentAnnouncement?.id,
        //           );
        //         },
        //         child: const Icon(Icons.arrow_back, color: Colors.white))
        //   ],
        // ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.images[index]),
                  initialScale: PhotoViewComputedScale.contained,
                );
              },
              onPageChanged: (int page) {
                setState(() {
                  activePage = page;
                });
              },
              itemCount: widget.images.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: AppAnimations.circleFadingAnimation,
                ),
              ),
              pageController: pageController,
            ),
          ),
          const SizedBox(height: 30),
          ImagesIndicators(length: widget.images.length, currentIndex: activePage, size: 10),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
