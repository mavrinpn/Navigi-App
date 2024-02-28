import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class ImageData {
  late final String? id;
  Uint8List bytes;
  bool compressed;

  ImageData(this.id, this.bytes, {this.compressed = true});

  ImageData.newImage(this.bytes) : compressed = false {
    id = _randomId();
  }

  String _randomId() {
    const id = Uuid();
    return id.v4();
  }

  // @override
  // bool operator ==(Object other) {
  //   if (other is ImageData) {
  //     return other.id == id;
  //   }
  //   return super == other;
  // }
}