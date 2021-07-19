import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class ComentarioAlertaProvider {
  var apiUrl = new UrlProvider().url();

  // OBTENER hogares //
  Future<List<dynamic>> comentarioListar() async {
    var urlRequest = apiUrl + 'comentariosAlerta';
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
  Future<List<dynamic>> comentarioAlertaListar(int id) async {
    var urlRequest = apiUrl + 'alertas/$id/comentarios';
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
  Future<http.Response> comentarioAgregar(
      String descripcion, String alertaId, String rut) async {
    DateTime fechaEmision = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second,
    );
    var urlRequest = apiUrl + 'comentariosAlerta';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'descripcion': descripcion,
          'fecha_emision': fechaEmision.toString(),
          'alerta_id': alertaId,
          'usuario_rut': rut
        }));
    var urlRequestAlerta = apiUrl + 'alertas/$alertaId/ultima';
    // TESTEAR ESTO //
    var respuestaAlerta = await http.post(Uri.parse(urlRequestAlerta),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'ultima_actividad': fechaEmision.toString()}));
    print(respuestaAlerta.statusCode);
    return respuesta;
  }

  // EDITAR hogares //
  Future<http.Response> comentarioEditar(
      int idComentario, String descripcion) async {
    var urlRequest = apiUrl + 'comentariosAlerta/$idComentario';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'descripcion': descripcion,
        }));
    return respuesta;
  }

  // BORRAR hogares//
  Future<http.Response> comentarioBorrar(int id) async {
    var urlRequest = apiUrl + 'comentariosAlerta/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getComentario(int idComentario) async {
    var urlRequest = apiUrl + 'comentariosAlerta/$idComentario';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
