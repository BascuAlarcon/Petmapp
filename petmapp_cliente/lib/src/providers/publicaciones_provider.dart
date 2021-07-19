import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class PublicacionProvider {
  // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
  // final apiUrl = 'http://10.0.2.2:8000/api/';
  // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
  // final apiUrl = 'http://192.168.1.93:8000/api/';

  var apiUrl = new UrlProvider().url();

  // OBTENER publicaciones //
  Future<List<dynamic>> publicacionListar() async {
    var urlRequest = apiUrl + 'publicaciones';
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

  // AGREGAR publicaciones //
  Future<http.Response> publicacionAgregar(
      String coordenadas, String descripcion, String tarifa, String rut) async {
    var urlRequest = apiUrl + 'publicaciones';
    var coor = coordenadas.split(';');
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'latitude': coor[0],
          'longitude': coor[1],
          'descripcion': descripcion,
          'tarifa': tarifa,
          'usuario_rut': rut
        }));
    return respuesta;
  }

  // EDITAR publicaciones //
  Future<http.Response> publicacionEditar(
      int idpublicacion, String descripcion, String tarifa) async {
    var urlRequest = apiUrl + 'publicaciones/$idpublicacion';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'descripcion': descripcion,
          'tarifa': tarifa,
        }));
    return respuesta;
  }

  // BORRAR publicaciones//
  Future<http.Response> publicacionesBorrar(int id) async {
    var urlRequest = apiUrl + 'publicaciones/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getpublicacion(
      int idpublicacion) async {
    var urlRequest = apiUrl + 'publicaciones/$idpublicacion';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
