import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class UsuarioProvider {
  var apiUrl = new UrlProvider().url();

// OBTENER publicaciones //
  Future<List<dynamic>> publicacionListar(token) async {
    var urlRequest = apiUrl + 'auth/me/publicaciones';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return new List<dynamic>();
      }
    } else {
      return new List<dynamic>();
    }
  }

// OBTENER PETICIONES DE DETERMINADA PUBLICACION //
  Future<LinkedHashMap<String, dynamic>> peticionListar(id) async {
    var urlRequest = apiUrl + 'publicaciones/$id/peticiones';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return new LinkedHashMap<String, dynamic>();
      }
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
