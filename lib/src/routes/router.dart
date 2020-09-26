import 'package:fasturista/src/pages/LoginPage.dart';
import 'package:fasturista/src/pages/OptimalPath.dart';
import 'package:fasturista/src/pages/SignUpPage.dart';
import 'package:fasturista/src/pages/WelcomePage.dart';
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

Widget getRoutePage(path, {parameters}) {
  switch (path) {
    case "/":
      return WelcomePage();
      break;
    case "profile":
      return Profile(
        userEmail: parameters["email"],
      );
      break;
    case "optimalpath":
      return OptimalPath();
      break;
    case "welcome":
      return WelcomePage();
      break;
    case "login":
      return LoginPage();
      break;
    case "signup":
      return SignUpPage();
      break;
    case "map":
      return WelcomePage();
      break;
    default:
      return MapTourist();
      break;
  }
}

// Widget getRoutePage(path) {
//   switch (path) {
//     case "/":
//       return WelcomePage();
//       break;
//     case "profile":
//       return Profile();
//       break;
//     case "optimalpath":
//       return OptimalPath();
//       break;
//     case "welcome":
//       return WelcomePage();
//       break;
//     case "login":
//       return LoginPage();
//       break;
//     case "signup":
//       return SignUpPage();
//       break;
//     case "map":
//       return WelcomePage();
//       break;
//     default:
//       return MapTourist();
//       break;
//   }
// }
