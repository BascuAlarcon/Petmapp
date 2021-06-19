import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class ServiciosProvider {
  var apiUrl = new UrlProvider().url();

  // OBTENER publicaciones //
  Future<List<dynamic>> serviciosListar(int id) async {
    var urlRequest = apiUrl + 'peticiones/$id/servicios';
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
  Future<http.Response> serviciosAgregar(String comentario, String monto,
      String fecha, String foto, String idPeticion) async {
    var urlRequest = apiUrl + 'servicios';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'comentario': comentario,
          'foto': foto,
          'monto': monto,
          'fecha': fecha,
          'peticion_id': idPeticion
        }));
    return respuesta;
  }

  // EDITAR publicaciones //
  Future<http.Response> serviciosEditar(String comentario, String monto,
      String fecha, String foto, String idServicio) async {
    var urlRequest = apiUrl + 'servicios/$idServicio';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'comentario': comentario,
          'foto': foto,
          'monto': monto,
          'fecha': fecha,
        }));
    return respuesta;
  }

  // BORRAR publicaciones//
  Future<http.Response> serviciosBorrar(int id) async {
    var urlRequest = apiUrl + 'servicios/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  Future<LinkedHashMap<String, dynamic>> getServicio(int idServicio) async {
    var urlRequest = apiUrl + 'servicios/$idServicio';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
