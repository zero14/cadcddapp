import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinData {
  String pinPath;
  String pinPathLocal;
  String avatarPath;
  String avatarPathLocal;
  LatLng location;
  String locationName;
  String locationAddress;
  bool showLocation;
  Color labelColor;

  PinData({
    this.pinPath,
    this.pinPathLocal,
    this.avatarPath,
    this.avatarPathLocal,
    this.location,
    this.locationName,
    this.locationAddress,
    this.showLocation,
    this.labelColor,
  });
}
