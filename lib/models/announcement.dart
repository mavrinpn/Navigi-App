import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/models/user.dart';

part 'creator_data.dart';

part 'place.dart';

class Announcement {
  final String title;
  final String description;
  final int totalViews;
  final double price;
  final bool active;
  List images;
  final String id;
  final StaticParameters staticParameters;
  final CityDistrict placeData;
  final CreatorData creatorData;
  late final Widget previewImage;
  final String _createdAt;
  late final Uint8List bytes;
  final Future<Uint8List> futureBytes;
  bool liked;
  final String? itemId;

  Announcement.fromJson({
    required Map<String, dynamic> json,
    required this.futureBytes,
    this.liked = false,
  })  : title = json['name'],
        description = json['description'],
        creatorData = CreatorData.fromJson(data: json['creator']),
        price = double.parse(json['price'].toString()),
        images = json['images'],
        staticParameters = StaticParameters(
          encodedParameters:
              json['parametrs'] is List ? json['parametrs'] : '[]',
        ),
        totalViews = json['total_views'] ?? 0,
        _createdAt = json['\$createdAt'],
        id = json['\$id'],
        active = json['active'],
        itemId = json['itemId'],
        placeData = CityDistrict.fromJson(json['place']) {
    var l = [];
    for (String i in images) {
      i.replaceAll('89.253.237.166', '143.244.206.96'); //admin.navigidz.online
      l.add(i);
    }
    images = l;
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
