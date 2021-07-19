import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class RazasProvider {
  var apiUrl = new UrlProvider().url();
  // RAZAS //
  // OBTENER RAZAS //
  Future<List<dynamic>> getRazas() {
    var urlRequest = apiUrl + 'razas';
    return _getData(urlRequest);
  }

  // METODO PRIVADO //
  Future<List<dynamic>> _getData(String url) async {
    var response = await http.get(Uri.parse(url));
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

  // AGREGAR RAZAS //
  Future<http.Response> razaAgregar(
      String nombre, String descripcion, String especie) async {
    var urlRequest = apiUrl + 'razas';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'nombre': nombre,
          'descripcion': descripcion,
          'especie_id': especie
        }));
    return respuesta;
  }

  // EDITAR RAZAS //
  Future<http.Response> razaEditar(
      int idRaza, String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'razas/$idRaza';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // BORRAR RAZAS//
  Future<http.Response> razasBorrar(int id) async {
    var urlRequest = apiUrl + 'razas/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getRaza(int idRaza) async {
    var urlRequest = apiUrl + 'razas/$idRaza';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // LISTAR MASCOTAS POR RAZAS //
  Future<LinkedHashMap<String, dynamic>> razasMascotas(int idRaza) async {
    var urlRequest = apiUrl + 'razas/$idRaza/mascotas';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
