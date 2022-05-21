import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '../Models/place_model.dart';
import 'AuthenticationService.dart';
import 'api_services.dart';

class LocationServices extends ChangeNotifier {
  final Api _api = Api(path: "posts");
  late List<Place> places;
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Future<LocationData?> getUserLocation() async {
    // Check if location service is enable
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    // Check if permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return _location.getLocation();
  }

  Future<List<Place>> fetchPlaces() async {
    var result = await _api.getDataCollection();
    places = result.docs
        .map((doc) => Place.fromFirestore(doc, SnapshotOptions()))
        .toList();
    notifyListeners();
    return places;
  }

  Stream<List<Place>?> fetchPlacesAsStream() {
    return _api
        .streamDataCollection()
        .map((event) => placeListFromSnapshot(event));
  }

  Stream<List<Place>?> fetchPlacesAsStreamByUID() {
    final _user = AuthService().getUser();
    return _api
        .streamDataCollectionByUID(_user!.uid)
        .map((event) => placeListFromSnapshot(event));
  }

  List<Place>? placeListFromSnapshot(QuerySnapshot snapshot) {
    var doc = snapshot.docs;
    return doc.map((doc2) {
      Place place = Place.fromFirestore(doc2, SnapshotOptions());
      place.id = doc2.id;
      return place;
    }).toList();
  }

  Future<Place> getPlaceById(String id) async {
    var doc = await _api.getDocumentById(id);
    Place place = Place.fromFirestore(doc, SnapshotOptions());
    place.id = doc.id;
    notifyListeners();
    return place;
  }

  Stream<Place> streamPlaceById(String id) {
    return _api.streamDocumentById(id).map((doc) {
      Place place = Place.fromFirestore(doc, SnapshotOptions());
      place.id = doc.id;
      notifyListeners();
      return place;
    });
  }

  Future removePlace(String id) async {
    await _api.removeDocument(id);
    notifyListeners();
    return;
  }

  Future updatePlace(Place data, String id) async {
    await _api.updateDocument(data.toFirestore(), id);
    notifyListeners();
    return;
  }

  Future addPlace(Place data) async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    data.token = token;
    var result = await _api.addDocument(data.toFirestore());
    notifyListeners();
    return result;
  }

  Stream<List<Place>?> fetchApprovedPlacesAsStream() {
    return _api
        .streamApprovedDataCollection()
        .map((event) => placeListFromSnapshot(event));
  }

  Stream<List<Place>?> fetchApprovedPlacesAsStreamByUID() {
    final _user = AuthService().getUser();
    return _api
        .streamApprovedDataCollectionByUID(_user!.uid)
        .map((event) => placeListFromSnapshot(event));
  }

  Stream<List<Place>?> searchPlacesAsStream({String? title, String? category}) {
    if (title != null && category == null) {
      return _api
          .streamSearchByTitle(title)
          .map((event) => placeListFromSnapshot(event));
    }
    if (category != null && title == null) {
      return _api.streamSearchByCategory(category).map((event) => placeListFromSnapshot(event));
    }
    return _api.streamSearchBoth(category!, title!).map((event) => placeListFromSnapshot(event));
  }

  Stream<List<Place>?> searchPlacesAsStreamByUID({required String category}) {
    final _user = AuthService().getUser();
    return _api.streamSearchByCategoryByUID(category, _user!.uid).map((event) => placeListFromSnapshot(event));
  }
}
