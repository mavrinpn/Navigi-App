import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart/models/item/static_parameters.dart';

part 'creator_data.dart';

part 'place.dart';

class Announcement {
  final String title;
  final String description;
  final int totalViews;
  final double price;
  List images;
  final String announcementId;
  final StaticParameters staticParameters;
  final PlaceData placeData;
  final CreatorData creatorData;
  late final Widget previewImage;
  final String _createdAt;
  late final Uint8List bytes;
  final Future<Uint8List> futureBytes;

  Announcement(this.bytes, this.futureBytes,
      {required this.title,
      required String created,
      required this.description,
      required this.totalViews,
      required this.price,
      required this.images,
      required this.previewImage,
      required this.announcementId,
      required this.staticParameters,
      required this.creatorData,
      required this.placeData})
      : _createdAt = created;

  Announcement.fromJson(
      {required Map<String, dynamic> json, required this.futureBytes})
      : title = json['name'],
        description = json['description'],
        creatorData = CreatorData.fromJson(data: json['creator']),
        price = double.parse(json['price'].toString()),
        images = json['images'],
        staticParameters = StaticParameters(parameters: json['parametrs']),
        totalViews = json['total_views'],
        _createdAt = json['\$createdAt'],
        announcementId = json['\$id'],
        placeData = PlaceData.fromJson(json['place']) {
    var l  = [];
    for (String i in images) {
      i.replaceAll('89.253.237.166', 'admin.navigidz.online');
      l.add(i);
    }
    images = l;
    loadBytes();
  }

  Announcement.fromJson2(
      {required Map<String, dynamic> json, required this.futureBytes})
      : title = json['name'],
        description = json['description'],
        creatorData = CreatorData(),
        price = double.parse(json['price'].toString()),
        images = json['images'],
        staticParameters = StaticParameters(parameters: json['parametrs']),
        totalViews = json['total_views'],
        _createdAt = json['\$createdAt'],
        announcementId = json['\$id'],
        placeData = PlaceData.fish() {
    loadBytes();
  }

  void loadBytes() async {
    bytes = await futureBytes;
  }

  @override
  String toString() => title;

  String get createdAt {
    final gotData = DateTime.parse(_createdAt);
    final String month = _addZeroInStart(gotData.month);
    final String day = _addZeroInStart(gotData.day);
    final String hour = _addZeroInStart(gotData.hour);
    final String minutes = _addZeroInStart(gotData.minute);
    return '$month.$day $hour:$minutes';
  }

  String _addZeroInStart(int num) =>
      num.toString().length > 1 ? num.toString() : '0$num';

  String get stringPrice {
    String reversed = price.toString().split('.')[0].split('').reversed.join();

    for (int i = 0; i < reversed.length; i += 4) {
      try {
        reversed = '${reversed.substring(0, i)} ${reversed.substring(i)}';
        // ignore: empty_catches
      } catch (e) {}
    }

    return '${reversed.split('').reversed.join()}DZD';
  }
}
