import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart/feature/announcement/ui/map.dart';
import 'package:smart/models/announcement.dart';

class AnnouncementMiniMap extends StatefulWidget {
  const AnnouncementMiniMap({
    super.key,
    required this.cityDistrict,
  });

  final CityDistrict cityDistrict;

  @override
  State<AnnouncementMiniMap> createState() => _AnnouncementMiniMapState();
}

class _AnnouncementMiniMapState extends State<AnnouncementMiniMap> {
  late CameraPosition cameraPosition;
  Set<Marker> markers = {};
  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    cameraPosition = CameraPosition(
      target: LatLng(
        widget.cityDistrict.latitude,
        widget.cityDistrict.longitude,
      ),
      zoom: 14,
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'Assets/map_marker.png')
        .then((icon) {
      markers.add(Marker(
        icon: icon,
        markerId: MarkerId(widget.cityDistrict.name),
        position: cameraPosition.target,
      ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cityDistrict.latitude == 0 &&
        widget.cityDistrict.longitude == 0) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MapScreen(
              placeData: widget.cityDistrict,
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
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              markers: markers,
            ),
          ),
        ),
      ),
    );
  }
}
