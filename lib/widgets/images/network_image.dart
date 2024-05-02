import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatefulWidget {
  CustomNetworkImage({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 14,
    required String url,
  }) : _image = NetworkImage(url);

  final NetworkImage _image;
  final double width;
  final double height;
  final double borderRadius;

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
          if (!mounted) return;
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
              decoration:
                  BoxDecoration(color: Colors.grey[300]!, borderRadius: BorderRadius.circular(widget.borderRadius)),
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              image: DecorationImage(
                image: widget._image,
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
