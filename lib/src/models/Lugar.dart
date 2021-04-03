class Itinerarios {
  List<Itinerario> items;

  Itinerarios.fromJsonList(List<dynamic> jsonList) {
    items = new List();
    for (var item in jsonList) {
      final itinerario = Itinerario.fromJsonMap(item);
      items.add(itinerario);
    }
  }
}

class Itinerario {
  int day;
  List<Lugar> lugares;

  Itinerario({
    this.day,
    this.lugares,
  });

  Itinerario.fromJsonMap(Map<String, dynamic> json) {
    if (json == null) return;

    this.day = json["day"];
    this.lugares = Lugares.fromJsonList(json["places"]).lugares;
  }
}

class Lugar {
  double lat;
  double lng;
  double duration;
  String formattedAddress;
  String formattedPhoneNumber;
  String name;
  String icon;
  String vicinity;
  String type;
  List<String> photos;
  Horario horario;

  Lugar({
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.lat,
    this.lng,
    this.name,
    this.icon,
    this.vicinity,
    this.photos,
    this.horario,
    this.type,
    this.duration,
  });

  Lugar.fromJsonMap(Map<String, dynamic> json) {
    this.formattedAddress =
        json["formatted_address"] != null ? json["formatted_address"] : "";
    this.formattedPhoneNumber = json["formatted_phone_number"] != null
        ? json["formatted_phone_number"]
        : "";
    this.lat = json["lat"];
    this.lng = json["lng"];
    this.name = json["name"];
    this.icon = json["icon"];
    this.vicinity = json["vicinity"];
    this.photos = null;
    this.horario = json["schedule"] != null
        ? Horario(
            inicio: json["schedule"]["start"], fin: json["schedule"]["end"])
        : null;
    this.type = json["type"];
    this.duration = json["duration"] != null ? json["duration"] / 1 : 0.0;
  }
}

class Horario {
  String inicio;
  String fin;

  Horario({this.inicio, this.fin});
}

class Lugares {
  List<Lugar> lugares;

  Lugares({this.lugares});

  Lugares.fromJsonList(List<dynamic> jsonList) {
    lugares = new List();

    if (jsonList == null) return;

    for (var item in jsonList) {
      final lugar = Lugar.fromJsonMap(item);

      lugares.add(lugar);
    }
  }
}
