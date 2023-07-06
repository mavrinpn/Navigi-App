import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/models/announcement.dart';

import '../../../utils/colors.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key, required this.placeData});

  final PlaceData placeData;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  @override
  Widget build(BuildContext context) {
    CameraPosition center = CameraPosition(
      target: LatLng(widget.placeData.x, widget.placeData.y),
      zoom: 14.4746,
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.dark,),
      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: center,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {
            Marker(
              markerId: MarkerId(widget.placeData.name),
              position: LatLng(widget.placeData.x, widget.placeData.y),
            )
          }),
    );
  }
}
