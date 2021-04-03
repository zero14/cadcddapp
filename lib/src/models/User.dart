import 'Trace.dart';

class User extends Trace {
  String name;
  String lastname;
  String email;
  String phone;
  String password;
  String birthday;
  List<String> preferences;

  User(
      {this.name,
      this.lastname,
      this.email,
      this.phone,
      this.password,
      this.preferences});

  User.fromJsonMap(Map<String, dynamic> json) {
    this.code = json["code"];
    this.message = json["message"];
    this.name = json["payload"]["name"];
    this.lastname = json["payload"]["lastname"];
    this.email = json["payload"]["email"];
    this.birthday = json["payload"]["birthday"];
    this.phone = json["payload"]["phone"];
    this.preferences =  List.castFrom(json["payload"]["preferences"]);
  }
}
