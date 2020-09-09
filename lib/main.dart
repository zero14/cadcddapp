import 'package:fasturista/src/pages/map.dart';
import 'package:fasturista/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(TouristRunApp());

class TouristRunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", "US"),
        const Locale("es", "ES"),
      ],
      debugShowCheckedModeBanner: false,
      title: 'fasturista',
      initialRoute: "/",
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings setting) {
        return MaterialPageRoute(
          builder: (context) => MapTourist(),
        );
      },
    );
  }
}
