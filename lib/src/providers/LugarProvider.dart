import 'dart:convert';

import 'package:fasturista/src/models/Lugar.dart';
import 'package:http/http.dart' as http;

class LugarProvider {
  final _url = "https://cadcdd.herokuapp.com";

  Future<List<Lugar>> _procesarRespuestaPOST(
      String path, Map<String, dynamic> parametros) async {
    final respuesta = await http.post(
      "$_url/$path",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(parametros),
    );

    final decodedData = json.decode(utf8.decode(respuesta.bodyBytes));

    final lugares = new Lugares.fromJsonList(decodedData);

    return lugares.items;
  }

  Future<List<Lugar>> getLugar(double latitude, double longitude) async {
    final path = "tours/suggest";
    Map<String, dynamic> parametros = {
      "total_days": 3,
      "location": {"latitude": latitude, "longitude": longitude},
      "categories": ["parque"],
      "start_date": "2020-08-21"
    };

    return await _procesarRespuestaPOST(path, parametros);
  }
}
