import 'dart:convert';

import 'package:fasturista/src/models/Lugar.dart';
import 'package:http/http.dart' as http;

class LugarProvider {
  // final _url = "https://cadcdd.herokuapp.com";
  final _url = "https://cadcdd.nn.r.appspot.com";

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
    final path = "tours/suggest";
    Map<String, dynamic> parametros = {
      "total_days": 3,
      "location": {"latitude": latitude, "longitude": longitude},
      "categories": textSearch != null && textSearch != ''
          ? ["$textSearch"]
          : ["parque", "Iglesia"],
      "start_date": "2020-09-29T00:00:00"
    };

    print("lat:$latitude , long:$longitude");

    return await _procesarRespuestaPOST(path, parametros);
  }
}
