import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class NegocioProvider {
  var apiUrl = new UrlProvider().url();

// AGREGAR UBICACION //
  Future<http.Response> negocioAgregar(
      String tipoNegocio,
      String foto,
      String descripcion,
      String direccion,
      String localizacion,
      String nombre,
      String horario) async {
    var urlRequest = apiUrl + 'negocios';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_id': tipoNegocio,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'localizacion': localizacion,
          'nombre': nombre,
          'horario': horario
        }));
    return respuesta;
  }

  // LISTAR ALERTAS //
  Future<List<dynamic>> negocioListar() async {
    var urlRequest = apiUrl + 'negocios';
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
  Future<http.Response> negocioEditar(
      int idNegocio,
      String tipoUbicacion,
      String foto,
      String descripcion,
      String direccion,
      String localizacion,
      String nombre,
      String horario) async {
    var urlRequest = apiUrl + 'negocios/$idNegocio';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_id': tipoUbicacion,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'localizacion': localizacion,
          'nombre': nombre,
          'horario': horario
        }));
    return respuesta;
  }

  // BORRAR ALERTA //
  Future<http.Response> negocioBorrar(int id) async {
    var urlRequest = apiUrl + 'negocios/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getNegocio(int idNegocio) async {
    var urlRequest = apiUrl + 'negocios/$idNegocio';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
