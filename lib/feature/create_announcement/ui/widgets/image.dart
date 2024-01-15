
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key,  this.path, required this.callback, this.bytes});

  final String? path;
  final Uint8List? bytes;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113,
      height: 106,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: 105,
              height: 98,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.red,
                  image: DecorationImage(
                      image: (path != null ? FileImage(File(path!)) : MemoryImage(bytes!)) as ImageProvider, fit: BoxFit.cover)),
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