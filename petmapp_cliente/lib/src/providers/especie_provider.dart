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

  // LISTAR RAZAS POR ESPECIE //
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

  // AGREGAR ESPECIES //
  Future<http.Response> especieAgregar(
      String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'especies';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // EDITAR ESPECIES //
  Future<http.Response> especieEditar(
      int idEspecie, String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'especies/$idEspecie';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // BORRAR ESPECIES //
  Future<http.Response> especieBorrar(int id) async {
    var urlRequest = apiUrl + 'especies/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getEspecie(int idEspecie) async {
    var urlRequest = apiUrl + 'especies/$idEspecie';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
