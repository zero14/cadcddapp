import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fasturista/src/models/puntointeres.dart';

class PuntoInteresProvider {
  final _url = "https://cadcdd.herokuapp.com";

  Future<List<PuntoInteres>> _procesarRespuestaGET(String path) async {
    final respuesta = await http.get("$_url/$path");

    final decodedData = json.decode(respuesta.body);

    final puntoIntereses = new PuntoIntereses.fromJsonList(decodedData);

    return puntoIntereses.items;
  }

  Future<List<PuntoInteres>> getPuntosInteres(
      double latitude, double longitude) async {
    final path =
        "tours/pois?latitude=$latitude&longitude=$longitude&categories=parque";

    return await _procesarRespuestaGET(path);
  }
}
