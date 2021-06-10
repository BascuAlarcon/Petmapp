import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class PeticionProvider {
  // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
  // final apiUrl = 'http://10.0.2.2:8000/api/';
  // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
  // final apiUrl = 'http://192.168.1.86:8000/api/';

  // OBTENER URL //
  var apiUrl = new UrlProvider().url();

  // OBTENER peticiones //
  Future<List<dynamic>> peticionListar() async {
    var urlRequest = apiUrl + 'peticiones';
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

  // AGREGAR peticiones //
  Future<http.Response> peticionAgregar(String fecha_inicio, String fecha_fin,
      String usuario_rut, String publicacion_id) async {
    var urlRequest = apiUrl + 'peticiones';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'fecha_inicio': fecha_inicio,
          'fecha_fin': fecha_fin,
          'usuario_rut': usuario_rut,
          'publicacion_id': publicacion_id
        }));
    print(respuesta);
    return respuesta;
  }

  // EDITAR peticiones //
  Future<http.Response> peticionEditar(
      int idpeticion,
      String fecha_inicio,
      String fecha_fin,
      String precio_total,
      String estado,
      String boleta) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'fecha_inicio': fecha_inicio,
          'fecha_fin': fecha_fin,
          'precio_total': precio_total,
          'estado': estado,
          'boleta': boleta
        }));
    return respuesta;
  }

  // BORRAR peticiones//
  Future<http.Response> peticionesBorrar(int id) async {
    var urlRequest = apiUrl + 'peticiones/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getpeticion(int idpeticion) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // RESPUESTA PETICION //
  Future<http.Response> peticionRespuesta(int idpeticion, String estado,
      String fechaInicio, String fechaFin, String precio) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'fecha_inicio': fechaInicio,
          'fecha_fin': fechaFin,
          'precio_total': precio,
          'estado': estado,
        }));
    return respuesta;
  }
}
