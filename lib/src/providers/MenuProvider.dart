import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class MenuProvider {
  List<dynamic> opciones = [];

  MenuProvider();

  Future<List<dynamic>> cargarData() async {
    final lista = await rootBundle.loadString('data/menu.json');

    Map dataMap = json.decode(lista);
    opciones = dataMap["paths"];

    return opciones;
  }
}

final menuProvider = new MenuProvider();
