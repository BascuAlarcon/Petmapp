import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class EspecieProvider {
  // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
  // final apiUrl = 'http://10.0.2.2:8000/api/';
  // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
  // final apiUrl = 'http://192.168.1.93:8000/api/';

  var apiUrl = new UrlProvider().url();

// OBTENER ESPECIES //
  Future<List<dynamic>> especieListar() async {
    var urlRequest = apiUrl + 'especies';
    var response = await http.get(Uri.parse(urlRequest));
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
}
