import 'dart:convert';

import 'package:fasturista/src/models/User.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  //final url = "http://192.168.0.4:8000";
  final url = "http://192.168.0.4:8000";

  Future<Map<String, dynamic>> _postData(
      String path, Map<String, dynamic> parameters) async {
    print("url:$url");
    final response = await http.post("$url/$path",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(parameters));

    final decodeData = json.decode(utf8.decode(response.bodyBytes));

    return decodeData;
  }

  Future<User> login(String email, String password) async {
    final path = "login";
    final Map<String, dynamic> parameters = {
      "email": email,
      "password": password
    };

    final response = await this._postData(path, parameters);

    print("MENSAJE RESPONSE");
    print(response);


    final user = new User.fromJsonMap(response);


    return user;
  }

}
