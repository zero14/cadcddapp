import 'package:fasturista/src/pages/OptimalPath.dart';
import 'package:fasturista/src/pages/map.dart';
import 'package:fasturista/src/pages/profile.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    "/": (BuildContext context) => MapTourist(),
    "profile": (BuildContext context) => Profile(),
    "optimalpath": (BuildContext context) => OptimalPath(),
  };
}

Widget getRoutePage(path) {
  switch (path) {
    case "/":
      return MapTourist();
      break;
    case "profile":
      return Profile();
      break;
    case "optimalpath":
      return OptimalPath();
      break;
    default:
      return MapTourist();
      break;
  }
}
