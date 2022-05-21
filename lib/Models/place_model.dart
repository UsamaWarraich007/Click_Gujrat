import 'dart:math' show cos, sqrt, asin;
import 'package:click_gujrat/Services/location_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Place {
  final String category;
  final String close;
  final String date;
  final String description;
  final String homeImage;
  final String openTime;
  final String title;
  final String uid;
  int likes;
  int commentsCount;
  String token;
  final LatLng? latLng;
  final List<String>? images;
  final String address;
  bool isApproved;
  String? id;

  Place({
    required this.category,
    required this.close,
    required this.date,
    required this.description,
    this.latLng,
    required this.homeImage,
    this.images,
    required this.commentsCount,
    required this.likes,
    required this.address,
    required this.openTime,
    required this.title,
    required this.uid,
    required this.token,
    required this.isApproved,
  }) : id = "";

  Place.fromFirestore(
      DocumentSnapshot<Object?> snapshot,
      SnapshotOptions? options,
      )   : title = snapshot["title"],
        category = snapshot["category"],
        uid = snapshot["uid"],
        close = snapshot["close"],
        date = snapshot["date"],
        description = snapshot["description"],
        openTime = snapshot["openTime"],
        token = snapshot["token"],
        commentsCount = snapshot["comments"],
        likes = snapshot["likes"],
        latLng = LatLng.fromJson(snapshot["latLng"]),
        images = List<String>.from(snapshot["imageList"].map((x) => x)),
        address = snapshot["location"],
        isApproved = snapshot["isApproved"],
        homeImage = snapshot["homeImage"];

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "category": category,
      "close": close,
      "likes": likes,
      "comments": commentsCount,
      "date": date,
      "description": description,
      "openTime": openTime,
      "uid": uid,
      "token": token,
      "location": address,
      "homeImage": homeImage,
      "isApproved": isApproved,
      if (images != null) "imageList": List<dynamic>.from(images!.map((e) => e)),
      if (latLng != null) "latLng" : latLng!.toJson(),
    };
  }

  Future<String> getDistance() async {
    final _userLocation = await LocationServices().getUserLocation();
    double distance = calculateDistance(latLng!.latitude, latLng!.longitude, _userLocation!.latitude!, _userLocation.longitude!);
    print("Distance::: ${latLng!.toJson()}");
    print("Distance@::: ${_userLocation.latitude} & ${_userLocation.longitude}");
    return distance.toStringAsFixed(1);
  }

  String remainingTime() {
    DateTime now = DateTime.now();
    DateTime parse = DateFormat.jm().parse(close);
    DateTime closeTime = DateTime(now.year, now.month, now.day, parse.hour, parse.minute, parse.microsecond);
    if (closeTime.isBefore(now)) {
      return "Closed";
    } else {
      Duration difference = closeTime.difference(now);
      if (!difference.isNegative) {
        return close;
      }
      return "Closed";
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }


}