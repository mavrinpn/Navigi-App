import 'package:flutter/material.dart';
import 'package:map_kit/map_kit.dart';
import 'package:map_kit_interface/map_kit.dart';
import 'package:smart/feature/announcement/ui/map.dart';
import 'package:smart/models/announcement.dart';

class AnnouncementMiniMap extends StatefulWidget {
  const AnnouncementMiniMap({
    super.key,
    required this.cityDistrict,
    required this.latitude,
    required this.longitude,
  });

  final CityDistrict cityDistrict;
  final double latitude;
  final double longitude;

  @override
  State<AnnouncementMiniMap> createState() => _AnnouncementMiniMapState();
}

class _AnnouncementMiniMapState extends State<AnnouncementMiniMap> {
  // late CameraPosition cameraPosition;
  // Set<Marker> markers = {};
  // BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;

  // @override
  // void initState() {
  //   super.initState();

  // cameraPosition = CameraPosition(
  //   target: LatLng(
  //     widget.latitude,
  //     widget.longitude,
  //   ),
  //   zoom: 14,
  // );

  // BitmapDescriptor.fromAssetImage(
  //         ImageConfiguration.empty, 'Assets/map_marker.png')
  //     .then((icon) {
  //   markers.add(Marker(
  //     icon: icon,
  //     // markerId: MarkerId(widget.cityDistrict.name),
  //     markerId: const MarkerId(''),
  //     position: cameraPosition.target,
  //   ));
  //   setState(() {});
  // });
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.latitude == 0 && widget.longitude == 0) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MapScreen(
              placeData: widget.cityDistrict,
              latitude: widget.latitude,
              longitude: widget.longitude,
            ),
          ),
        );
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            height: 220,
            child: CommonMap().buildMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initial: CommonLatLng(widget.latitude, widget.longitude),
              markers: {
                CommonLatLng(widget.latitude, widget.longitude),
              },
            ),
            // child: GoogleMap( //TODO
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: false,
            //   zoomControlsEnabled: false,
            //   mapType: MapType.normal,
            //   initialCameraPosition: cameraPosition,
            //   markers: markers,
            // ),
          ),
        ),
      ),
    );
  }
}
