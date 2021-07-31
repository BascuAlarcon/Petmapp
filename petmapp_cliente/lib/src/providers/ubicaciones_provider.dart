import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class UbicacionProvider {
  var apiUrl = new UrlProvider().url();

// AGREGAR UBICACION //
  Future<http.Response> ubicacionAgregar(
      String tipoUbicacion,
      String foto,
      String descripcion,
      String direccion,
      String latitud,
      String longitud) async {
    var urlRequest = apiUrl + 'ubicaciones';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_ubicacion': tipoUbicacion,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'latitud': latitud,
          'longitud': longitud
        }));
    return respuesta;
  }

  // LISTAR ALERTAS //
  Future<List<dynamic>> ubicacionListar() async {
    var urlRequest = apiUrl + 'ubicaciones';
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

  // EDITAR ALERTA //
  Future<http.Response> ubicacionEditar(
      int idUbicacion,
      String tipoUbicacion,
      String foto,
      String descripcion,
      String direccion,
      String latitud,
      String longitud) async {
    var urlRequest = apiUrl + 'ubicaciones/$idUbicacion';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_ubicacion': tipoUbicacion,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'latitud': latitud,
          'longitud': longitud
        }));
    return respuesta;
  }

  // BORRAR ALERTA //
  Future<http.Response> ubicacionBorrar(int id) async {
    var urlRequest = apiUrl + 'ubicaciones/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getUbicacion(int idUbicacion) async {
    var urlRequest = apiUrl + 'ubicaciones/$idUbicacion';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
