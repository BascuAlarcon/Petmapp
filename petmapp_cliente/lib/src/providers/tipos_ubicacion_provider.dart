import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class TipoUbicacionProvider {
  var apiUrl = new UrlProvider().url();

// AGREGAR UBICACION //
  Future<http.Response> tipoAgregar(  String nombre) async {
    var urlRequest = apiUrl + 'tiposUbicacion';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{ 
          'nombre': nombre
        }));
    return respuesta;
  }

  // LISTAR ALERTAS //
  Future<List<dynamic>> tipoListar() async {
    var urlRequest = apiUrl + 'tiposUbicacion';
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
  Future<http.Response> tipoEditar(
      int idTipo,   String nombre) async {
    var urlRequest = apiUrl + 'tiposUbicacion/$idTipo';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{ 
          'nombre': nombre
        }));
    return respuesta;
  }

  // BORRAR ALERTA //
  Future<http.Response> tipoBorrar(int id) async {
    var urlRequest = apiUrl + 'tiposUbicacion/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getTipo(int idTipo) async {
    var urlRequest = apiUrl + 'tiposUbicacion/$idTipo';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
