import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/models/announcement.dart';

import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';

class Aboba extends StatelessWidget {
  const Aboba({super.key, required this.placeData});

  final CityDistrict placeData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dark,
      ),
      body: MapSample(
        placeData: placeData,
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key, required this.placeData});

  final CityDistrict placeData;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;
  bool loading = true;

  @override
  void initState() {
    loadMarker();
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

  void showInformation() {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
            color: AppColors.whiteGray,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Container(width: 100, height: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.white),),
              const SizedBox(height: 20,),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: ' ${widget.placeData.name}',
                        style: AppTypography.font14black.copyWith(fontSize: 20)),
                    TextSpan(
                        text: '  4 km',
                        style: AppTypography.font14lightGray.copyWith(fontSize: 20)),
                  ]))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition center = CameraPosition(
      target: LatLng(widget.placeData.latitude, widget.placeData.longitude),
      zoom: 14.4746,
    );

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      body: loading
          ? const Center(
              child: Text('loading'),
            )
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: center,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                  Marker(
                    icon: customMarker,
                    markerId: MarkerId(widget.placeData.name),
                    position: LatLng(widget.placeData.latitude, widget.placeData.longitude),
                  )
                }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 35,),
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.dark,
            child: IconButton(
              onPressed: () => showInformation(),
              icon: const Icon(
                Icons.expand_less,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
