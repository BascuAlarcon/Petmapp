import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class EspecieProvider {
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

  Future<LinkedHashMap<String, dynamic>> razasListar(id) async {
    var urlRequest = apiUrl + 'especies/$id/razas';
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
