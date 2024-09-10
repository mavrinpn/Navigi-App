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
  // bool loading = true;

  // BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;
  // late final CameraPosition initialCenter;
  // late CameraPosition markerPosition;
  // late Marker marker;
  late final CommonLatLng initialCenter;
  late CommonLatLng markerPosition;

  @override
  void initState() {
    // loadMarker();
    // initialCenter = CameraPosition(
    //   target: LatLng(widget.latitude, widget.longitude),
    //   zoom: 14.4746,
    // );
    // markerPosition = initialCenter;
    // marker = Marker(
    //   icon: customMarker,
    //   markerId: MarkerId(widget.placeData.name),
    //   position: markerPosition.target,
    // );
    initialCenter = CommonLatLng(widget.latitude, widget.longitude);
    markerPosition = initialCenter;

    super.initState();
  }

  // void loadMarker() async {
  // final icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'Assets/map_marker.png');
  // setState(() {
  //   customMarker = icon;
  //   loading = false;
  // });
  // }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.specifyPlace),
      ),
      body:
          // loading
          // ? Center(
          //     child: Text(localizations.loading),
          //   )
          CommonMap().buildMap(
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
      ), //TODO
      // : GoogleMap(
      //     myLocationEnabled: true,
      //     myLocationButtonEnabled: true,
      //     zoomControlsEnabled: false,
      //     mapType: MapType.normal,
      //     initialCameraPosition: initialCenter,
      //     // onMapCreated: (GoogleMapController controller) {
      //     //   _controller.complete(controller);
      //     // },
      //     onTap: (CommonLatLng target) {
      //       setState(() {
      //         markerPosition = CameraPosition(target: target);
      //         marker = Marker(
      //           icon: customMarker,
      //           markerId: MarkerId(widget.placeData.name),
      //           position: markerPosition.target,
      //         );
      //       });
      //     },
      //     markers: {marker},
      //   ),
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
