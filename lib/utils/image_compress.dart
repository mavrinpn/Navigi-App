import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';

Future<Uint8List> resizeAndcompressImage(Uint8List list) async {
  const width = 2000;
  const quality = 90;

  Image? img = decodeImage(list);
  if (img != null) {
    Image resized = copyResize(img, width: width);
    Uint8List resizedData = encodeJpg(resized);

    return FlutterImageCompress.compressWithList(
      resizedData,
      minWidth: width,
      quality: quality,
    );
  }

  return FlutterImageCompress.compressWithList(
    list,
    minWidth: width,
    quality: quality,
  );
}

Future<Uint8List> resizeAndcompressThumb(Uint8List list) async {
  const width = 512;
  const quality = 95;

  Image? img = decodeImage(list);
  if (img != null) {
    Image resized = copyResize(img, width: width);
    Uint8List resizedData = encodeJpg(resized);

    return FlutterImageCompress.compressWithList(
      resizedData,
      minWidth: width,
      quality: quality,
    );
  }

  return FlutterImageCompress.compressWithList(
    list,
    minWidth: width,
    quality: quality,
  );
}
