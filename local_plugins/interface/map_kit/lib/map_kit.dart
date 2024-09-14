// ignore_for_file: public_member_api_docs, sort_constructors_first
library map_kit_interface;

import 'package:flutter/material.dart';

abstract class CommonMapInterface {
  Widget buildMap({
    required CommonLatLng initial,
    required bool myLocationEnabled,
    required bool myLocationButtonEnabled,
    required bool zoomControlsEnabled,
    required Set<CommonLatLng> markers,
    Function(CommonLatLng)? onTap,
  });
}

class CommonLatLng {
  final double _latitude;
  final double _longitude;

  CommonLatLng(
    this._latitude,
    this._longitude,
  );

  double get latitude => _latitude;
  double get longitude => _longitude;

  @override
  String toString() {
    return '$_latitude, $_longitude';
  }
}
