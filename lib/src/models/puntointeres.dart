class PuntoInteres {
  double latitude;
  double longitude;

  PuntoInteres({this.latitude, this.longitude});

  PuntoInteres.fromJsonMap(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class PuntoIntereses {
  List<PuntoInteres> items = new List();

  PuntoIntereses();

  PuntoIntereses.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final puntoInteres = PuntoInteres.fromJsonMap(item);
      items.add(puntoInteres);
    }
  }
}
