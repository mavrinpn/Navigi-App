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
          ),
        ),
      ),
    );
  }
}
