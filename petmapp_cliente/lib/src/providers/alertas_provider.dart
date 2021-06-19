import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class AlertaProvider {
  var apiUrl = new UrlProvider().url();

// AGREGAR MASCOTA //
  Future<http.Response> alertaAgregar(
      String rut,
      String tipoAlerta,
      String foto,
      String descripcion,
      String direccion,
      String localizacion,
      String habilitado,
      String ultimaActividad) async {
    var urlRequest = apiUrl + 'alertas';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'usuario_rut': rut,
          'tipo_alerta': tipoAlerta,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'localizacion': localizacion,
          'habilitado': habilitado,
          'ultima_actividad': ultimaActividad
        }));
    return respuesta;
  }

  // LISTAR ALERTAS //
  Future<List<dynamic>> alertaListar() async {
    var urlRequest = apiUrl + 'alertas';
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
  Future<http.Response> alertaEditar(
      int idAlerta,
      String tipoAlerta,
      String foto,
      String descripcion,
      String direccion,
      String localizacion,
      String habilitado,
      String ultimaActividad) async {
    var urlRequest = apiUrl + 'alertas/$idAlerta';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tipo_alerta': tipoAlerta,
          'foto': foto,
          'descripcion': descripcion,
          'direccion': direccion,
          'localizacion': localizacion,
          'habilitado': habilitado,
          'ultima_actividad': ultimaActividad
        }));
    return respuesta;
  }

  // BORRAR ALERTA //
  Future<http.Response> alertaBorrar(int id) async {
    var urlRequest = apiUrl + 'alertas/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getAlerta(int idAlerta) async {
    var urlRequest = apiUrl + 'alertas/$idAlerta';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
