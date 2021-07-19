import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class HogarProvider {
  // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
  // final apiUrl = 'http://10.0.2.2:8000/api/';
  // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
  // final apiUrl = 'http://192.168.1.93:8000/api/';

  var apiUrl = new UrlProvider().url();

  // OBTENER hogares //
  Future<List<dynamic>> hogarListar() async {
    var urlRequest = apiUrl + 'hogares';
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

  // AGREGAR hogares //
  Future<http.Response> hogarAgregar(
      String tipo,
      String disponibilidad,
      String direccion,
      String descripcion,
      String foto,
      String longitud,
      String latitud,
      String rut) async {
    var urlRequest = apiUrl + 'hogares';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_hogar': tipo,
          'disponibilidad_patio': disponibilidad,
          'direccion': direccion,
          'descripcion': descripcion,
          'foto': foto,
          'longitud': longitud,
          'latitud': latitud,
          'usuario_rut': rut
        }));
    return respuesta;
  }

  // EDITAR hogares //
  Future<http.Response> hogarEditar(
      int idhogar,
      String tipo,
      String disponibilidad,
      String direccion,
      String descripcion,
      String foto,
      String longitud,
      String latitud) async {
    var urlRequest = apiUrl + 'hogares/$idhogar';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_hogar': tipo,
          'disponibilidad_patio': disponibilidad,
          'direccion': direccion,
          'descripcion': descripcion,
          'foto': foto,
          'longitud': longitud,
          'latitid': latitud
        }));
    return respuesta;
  }

  // BORRAR hogares//
  Future<http.Response> hogaresBorrar(int id) async {
    var urlRequest = apiUrl + 'hogares/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> gethogar(int idhogar) async {
    var urlRequest = apiUrl + 'hogares/$idhogar';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
