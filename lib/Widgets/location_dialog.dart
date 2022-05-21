import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDialog extends StatefulWidget {
  const LocationDialog({Key? key, required this.latLng}) : super(key: key);
final LatLng latLng;

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final _markers = <Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGooglePlex;

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: widget.latLng,
      zoom: 14.4746,
    );
    addMarker(widget.latLng);
    super.initState();
  }

  void addMarker(LatLng latLng) {
    _markers.add(
      Marker(
        markerId: MarkerId('sourcePin${latLng.latitude}'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker,
        // alpha: .5,
      ),
    );
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 4/5,
      height: Get.height / 3,
      child: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
