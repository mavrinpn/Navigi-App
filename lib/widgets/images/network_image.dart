import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatefulWidget {
  CustomNetworkImage(
      {super.key,
      required this.width,
      required this.height,
      required String url})
      : _image = NetworkImage(url);

  NetworkImage _image;
  final double width;
  final double height;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    widget._image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (info, call) {
          setState(() {
            loading = false;
          });
        },
      ),
    );

    return loading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(14)),
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image:
                    DecorationImage(image: widget._image, fit: BoxFit.cover)),
          );
  }
}
