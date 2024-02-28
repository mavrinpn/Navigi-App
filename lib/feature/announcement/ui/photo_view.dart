import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart/feature/announcement/ui/announcement_screen.dart';
import 'package:smart/feature/announcement/ui/widgets/images_amount_indicators.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/utils/utils.dart';

class PhotoViews extends StatefulWidget {
  const PhotoViews({super.key});

  @override
  State<PhotoViews> createState() => _PhotoViewsState();
}

class _PhotoViewsState extends State<PhotoViews> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: activePage);

    final currentAnnouncement =
        RepositoryProvider.of<AnnouncementManager>(context).lastAnnouncement;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const AnnouncementScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AnnouncementScreen()));
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white))
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        NetworkImage(currentAnnouncement.images[index]),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemCount: currentAnnouncement!.images.length,
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
            const SizedBox(
              height: 30,
            ),
            ImagesIndicators(
                length: currentAnnouncement.images.length,
                currentIndex: activePage,
                size: 10),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
