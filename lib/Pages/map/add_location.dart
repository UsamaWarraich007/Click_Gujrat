import 'dart:async';
import 'package:location/location.dart' as location_manager;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Widgets/toaster.dart';
import '../../utils/Colors.dart';
import '../../utils/dimentions.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  late location_manager.Location location;
  bool _serviceEnabled = false;
  final _markers = <Marker>{};
  LatLng? _latLng;
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  location_manager.PermissionStatus _permissionGranted =
      location_manager.PermissionStatus.denied;
  bool isLoading = false;
  late String errorMessage;

  @override
  void initState() {
    location = location_manager.Location();
    _getUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((value) => value.dispose());
  }

  Future<void> _getUserLocation() async {
    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == location_manager.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != location_manager.PermissionStatus.granted) {
        return;
      }
    }
    updateLocation();
  }

  void addMarker(LatLng latLng) {
    _latLng = latLng;
    _markers.add(
      Marker(
        markerId: MarkerId('sourcePin${latLng.latitude}'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker,
        // alpha: .5,
      ),
    );
  }

  void removeMarker(LatLng latLng) {
    if (_latLng != null) {
      _markers.removeWhere((element) =>
          element.markerId == MarkerId('sourcePin${_latLng!.latitude}'));
    }
    addMarker(latLng);
  }

  void updateLocation() {
    location.getLocation().then((location_manager.LocationData cLoc) {
      _kGooglePlex = CameraPosition(
        target: LatLng(cLoc.latitude ?? 37.42796133580664,
            cLoc.longitude ?? -122.085749655962),
        zoom: 14.4746,
      );
      _controller.future.then((value) =>
          value.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex)));
      addMarker(_kGooglePlex.target);
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              compassEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,

              initialCameraPosition: _kGooglePlex,
              onTap: (latLng) {
                setState(() {
                  _kGooglePlex = CameraPosition(target: latLng, zoom: 14.4746,);
                });
                _controller.future.then(
                  (value) => value.animateCamera(
                    CameraUpdate.newCameraPosition(
                      _kGooglePlex,
                    ),
                  ),
                );
                removeMarker(latLng);
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.buttonColor,
                  ),
                  onPressed: () async {
                    if (_latLng == null) {
                      Toaster.showToast("Please select any location from map");
                      return;
                    }
                    Navigator.pop(context, _latLng);
                  },
                  child: const Text('Select')),
            ),
            Positioned(
                left: Dimensions.width15,
                top: 30,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.buttonColor,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(AddLocation._kLake));
  }
}
