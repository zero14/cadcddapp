import 'dart:convert';

import 'package:fasturista/src/models/Lugar.dart';
import 'package:http/http.dart' as http;

class LugarProvider {
  final _url = "https://cadcdd.herokuapp.com";

  Future<List<Itinerario>> _procesarRespuestaPOST(
      String path, Map<String, dynamic> parametros) async {
    final respuesta = await http.post(
      "$_url/$path",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(parametros),
    );

    final decodedData = json.decode(utf8.decode(respuesta.bodyBytes));

    print(decodedData["itinerary_plan"]);

    final itinerarios =
        new Itinerarios.fromJsonList(decodedData["itinerary_plan"]);

    return itinerarios.items;
  }

  Future<List<Itinerario>> getItinerario(
      double latitude, double longitude, String textSearch) async {
    print("LAITUDE:$latitude,LONGITUDE:$longitude");
    final path = "tours/suggest";
    Map<String, dynamic> parametros = {
      "total_days": 3,
      "location": {"latitude": latitude, "longitude": longitude},
      "categories": textSearch != null && textSearch != ''
          ? ["$textSearch"]
          : ["parque", "Iglesia"],
      "start_date": "2020-08-21"
    };

    return await _procesarRespuestaPOST(path, parametros);
  }
}
