import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final _icons = <String, IconData>{
  "add_alert": Icons.add_alert,
  "accessibility": Icons.accessibility,
  "folder_open": Icons.folder_open,
  "donut_large": Icons.donut_large,
  "input": Icons.input,
  "slider": Icons.slideshow,
  "listview": Icons.format_list_bulleted,
  "account_box": Icons.account_box,
  "settings": Icons.settings,
  "travel": Icons.directions_run,
};

final _iconsMarker = <String, String>{
  "park": "Icons.add_alert",
  "parque": "",
};

Icon getIcon(String nombreIcono) {
  return Icon(_icons[nombreIcono]);
}

String getIconMarker(String icon) {
  return _iconsMarker[icon];
}
