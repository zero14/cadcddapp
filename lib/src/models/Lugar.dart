class Lugar {
  String adrAddress;
  BusinessStatus businessStatus;
  String formattedAddress;
  String formattedPhoneNumber;
  Geometry geometry;
  String icon;
  String internationalPhoneNumber;
  String name;
  OpeningHours openingHours;
  List<Photo> photos;
  String placeId;
  double rating;
  String reference;
  List<TopLevelType> types;
  String url;
  int userRatingsTotal;
  int utcOffset;
  String vicinity;
  String website;
  int dayNumber;

  Lugar({
    this.adrAddress,
    this.businessStatus,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.geometry,
    this.icon,
    this.internationalPhoneNumber,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.rating,
    this.reference,
    this.types,
    this.url,
    this.userRatingsTotal,
    this.utcOffset,
    this.vicinity,
    this.website,
  });

  Lugar.fromJsonMap(Map<String, dynamic> json) {
    if (json == null) return;
    this.formattedAddress = json["formatted_address"];
    this.formattedPhoneNumber = json["formatted_phone_number"];
    this.geometry = new Geometry(
      location: Location(
          lat: json["geometry"]["location"]["lat"],
          lng: json["geometry"]["location"]["lng"]),
    );
    this.icon = json["icon"];
    this.name = json["name"];
    // this.openingHours = json["opening_hours"];
    this.placeId = json["place_id"];
    // this.rating = json["rating"] ? json["rating"] / 1 : json["rating"];
    // this.types = json["types"];
    this.vicinity = json["vicinity"];
  }
}

class Lugares {
  List<Lugar> items = new List();

  Lugares.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    int index = 0;

    for (var lugares in jsonList) {
      index++;
      for (var item in lugares) {
        final lugar = Lugar.fromJsonMap(item);
        lugar.dayNumber = index;
        items.add(lugar);
      }
    }
  }
}

enum BusinessStatus { OPERATIONAL }

class Geometry {
  Location location;

  Geometry({
    this.location,
  });
}

class Location {
  double lat;
  double lng;

  Location({
    this.lat,
    this.lng,
  });
}

class OpeningHours {
  bool openNow;
  List<Period> periods;
  List<String> weekdayText;

  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });
}

class Period {
  Open open;
  Open close;

  Period({
    this.open,
    this.close,
  });
}

class Open {
  int day;
  String time;

  Open({
    this.day,
    this.time,
  });
}

class Photo {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });
}

enum Language { ES, EN }

enum TopLevelType { PARK, POINT_OF_INTEREST, ESTABLISHMENT, TOURIST_ATTRACTION }
