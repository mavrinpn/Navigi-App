import 'package:flutter/material.dart';
import 'package:map_kit/map_kit.dart';
import 'package:map_kit_interface/map_kit.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/widgets/button/custom_text_button.dart';

class SpecifyPlaceScreen extends StatefulWidget {
  const SpecifyPlaceScreen({
    super.key,
    required this.placeData,
    required this.longitude,
    required this.latitude,
  });

  final CityDistrict placeData;
  final double longitude;
  final double latitude;

  @override
  State<SpecifyPlaceScreen> createState() => SpecifyPlaceScreenState();
}

class SpecifyPlaceScreenState extends State<SpecifyPlaceScreen> {
  late final CommonLatLng initialCenter;
  late CommonLatLng markerPosition;

  @override
  void initState() {
    initialCenter = CommonLatLng(widget.latitude, widget.longitude);
    markerPosition = initialCenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.specifyPlace),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: CommonMap().buildMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initial: initialCenter,
        markers: {markerPosition},
        onTap: (CommonLatLng position) {
          setState(() {
            markerPosition = position;
          });
        },
      ),
      floatingActionButton: CustomTextButton.orangeContinue(
        callback: () {
          Navigator.pop(context, markerPosition);
        },
        width: 200,
        text: localizations.change,
        active: true,
      ),
    );
  }
}
