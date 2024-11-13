import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_kit_interface/map_kit.dart';
import 'package:latlong2/latlong.dart';

class CommonMap extends CommonMapInterface {
  @override
  Widget buildMap({
    required CommonLatLng initial,
    required bool myLocationEnabled,
    required bool myLocationButtonEnabled,
    required bool zoomControlsEnabled,
    required Set<CommonLatLng> markers,
    Function(CommonLatLng)? onTap,
  }) {
    return FlutterMap(
      options: MapOptions(
        initialZoom: 14,
        initialCenter: LatLng(initial.latitude, initial.longitude),
        onTap: (tapPosition, point) {
          onTap?.call(CommonLatLng(point.latitude, point.longitude));
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: markers
              .map(
                (item) => Marker(
                  point: LatLng(item.latitude, item.longitude),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  rotate: true,
                  child: Image.asset(
                    'Assets/map_marker_big.png',
                    package: 'map_kit_interface',
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
