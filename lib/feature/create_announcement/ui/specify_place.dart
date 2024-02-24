import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class SpecifyPlaceScreen extends StatefulWidget {
  const SpecifyPlaceScreen({super.key, required this.placeData});

  final CityDistrict placeData;

  @override
  State<SpecifyPlaceScreen> createState() => SpecifyPlaceScreenState();
}

class SpecifyPlaceScreenState extends State<SpecifyPlaceScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;
  bool loading = true;

  late final CameraPosition initialCenter;
  late CameraPosition markerPosition;
  late Marker marker;

  @override
  void initState() {
    loadMarker();
    initialCenter = CameraPosition(
      target: LatLng(widget.placeData.latitude, widget.placeData.longitude),
      zoom: 14.4746,
    );
    markerPosition = initialCenter;
    marker = Marker(
      icon: customMarker,
      markerId: MarkerId(widget.placeData.name),
      position: markerPosition.target,
    );
    super.initState();
  }

  void loadMarker() async {
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'Assets/map_marker.png');
    setState(() {
      customMarker = icon;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Specify place'),), // TODO localize
      body: loading
          ? const Center(
        child: Text('loading'),
      )
          : GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: initialCenter,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (LatLng target) {
            setState(() {
              markerPosition = CameraPosition(target: target);
              marker = Marker(
                icon: customMarker,
                markerId: MarkerId(widget.placeData.name),
                position: markerPosition.target,
              );
            });
          },
          markers: {marker}),
      floatingActionButton: CustomTextButton.orangeContinue(
        callback: () {
          Navigator.pop(context, markerPosition.target);
        },
        width: 200,
        text: 'change', // TODO localize
        active: true,
      ),
    );
  }
}
