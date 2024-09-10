import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_kit_interface/map_kit.dart';

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
    // ignore: deprecated_member_use
    final iconFuture = BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'Assets/map_marker.png',
      package: 'map_kit_interface',
    );

    return FutureBuilder(
      future: iconFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final iconMarker = snapshot.data!;

          return GoogleMap(
            myLocationEnabled: myLocationEnabled,
            myLocationButtonEnabled: myLocationButtonEnabled,
            zoomControlsEnabled: zoomControlsEnabled,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(initial.latitude, initial.longitude),
              zoom: 14,
            ),
            markers: {
              ...markers.map(
                (item) => Marker(
                  icon: iconMarker,
                  markerId: MarkerId('$item'),
                  position: LatLng(item.latitude, item.longitude),
                ),
              ),
            },
            onTap: (argument) {
              onTap?.call(CommonLatLng(argument.latitude, argument.longitude));
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
