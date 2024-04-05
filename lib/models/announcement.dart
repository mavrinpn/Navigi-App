import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart/models/item/static_parameters.dart';
import 'package:smart/models/user.dart';
import 'package:smart/utils/price_type.dart';

part 'creator_data.dart';

part 'place.dart';

class Announcement {
  final String title;
  final String subcategoryId;
  final String description;
  final int totalViews;
  final int contactsViews;
  final double price;
  final PriceType priceType;
  final bool active;
  List images;
  final String id;
  final StaticParameters staticParameters;
  final CityDistrict area;
  final String cityName;
  final CreatorData creatorData;
  late final Widget previewImage;
  final String _createdAt;
  Uint8List? bytes;
  final Future<Uint8List> futureBytes;
  bool liked;
  final String? itemId;
  final String model;
  final String mark;
  final double latitude;
  final double longitude;

  Announcement.fromJson({
    required Map<String, dynamic> json,
    required this.futureBytes,
    this.liked = false,
  })  : title = json['name'],
        subcategoryId = json['subcategoryId'],
        description = json['description'],
        creatorData = CreatorData.fromJson(data: json['creator']),
        price = double.parse(json['price'].toString()),
        priceType = PriceTypeExtendion.fromString(json['price_type']),
        images = json['images'],
        staticParameters = json['parametrs'] is String
            ? StaticParameters(encodedParameters: '${json['parametrs']}')
            : StaticParameters(encodedParameters: '[]'),
        totalViews = json['total_views'] ?? 0,
        contactsViews = json['contacts_views'] ?? 0,
        _createdAt = json['\$createdAt'],
        id = json['\$id'],
        active = json['active'],
        itemId = json['itemId'],
        model = json['model'] ?? '',
        mark = json['mark'] ?? '',
        longitude = double.tryParse('${json['longitude']}') ?? 0,
        latitude = double.tryParse('${json['latitude']}') ?? 0,
        cityName = json['city'] != null ? json['city']['name'] : '',
        area = json['area2'] != null ? CityDistrict.fromJson(json['area2']) : CityDistrict.none() {
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

  String _addZeroInStart(int num) => num.toString().length > 1 ? num.toString() : '0$num';

  String get stringPrice {
    final convertedPrice = priceType.convertDzdToCurrency(price);
    final priceTypeString = priceType.name.toUpperCase();

    if (priceType == PriceType.mlrd) {
      final oCcy = NumberFormat("#,##0.00", "en_US");
      final priceString = oCcy.format(convertedPrice).replaceAll(',', ' ');
      return '$priceString $priceTypeString';
    } else {
      final oCcy = NumberFormat("#,##0", "en_US");
      final priceString = oCcy.format(convertedPrice).replaceAll(',', ' ');
      return '$priceString $priceTypeString';
    }
  }

  // String get stringDZDPrice {
  //   String reversed = price.toString().split('.')[0].split('').reversed.join();

  //   for (int i = 0; i < reversed.length; i += 4) {
  //     try {
  //       reversed = '${reversed.substring(0, i)} ${reversed.substring(i)}';
  //       // ignore: empty_catches
  //     } catch (e) {}
  //   }

  //   return '${reversed.split('').reversed.join()}DZD';
  // }
}
