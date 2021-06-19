import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class ComentarioNegocioProvider {
  var apiUrl = new UrlProvider().url();

  // OBTENER hogares //
  Future<List<dynamic>> comentarioListar() async {
    var urlRequest = apiUrl + 'comentariosNegocio';
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

  // LISTAR COMENTARIOS DE X ALERTA
  Future<List<dynamic>> comentarioNegocioListar(int id) async {
    var urlRequest = apiUrl + 'negocios/$id/comentarios';
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
  Future<http.Response> comentarioAgregar(String descripcion,
      String fechaEmision, String foto, String negocioId, String rut) async {
    var urlRequest = apiUrl + 'comentariosNegocio';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'descripcion': descripcion,
          'fecha_emision': fechaEmision,
          'foto': foto,
          'negocio_id': negocioId,
          'usuario_rut': rut
        }));
    return respuesta;
  }

  // EDITAR hogares //
  Future<http.Response> comentarioEditar(int idComentario, String descripcion,
      String fechaEmision, String foto) async {
    var urlRequest = apiUrl + 'comentariosNegocio/$idComentario';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'descripcion': descripcion,
          'fecha_emision': fechaEmision,
          'foto': foto,
        }));
    return respuesta;
  }

  // BORRAR hogares//
  Future<http.Response> comentarioBorrar(int id) async {
    var urlRequest = apiUrl + 'comentariosNegocio/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getComentario(int idComentario) async {
    var urlRequest = apiUrl + 'comentariosNegocio/$idComentario';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
