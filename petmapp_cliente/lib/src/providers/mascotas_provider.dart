import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class MascotaProvider {
  var apiUrl = new UrlProvider().url();

// AGREGAR MASCOTA //
  Future<http.Response> mascotaAgregar(
      String rut,
      String nombre,
      String estirilizacion,
      String fechaNacimiento,
      String condicionMedica,
      String microchip,
      String alimentos,
      String personalidad,
      String sexo,
      String raza) async {
    var urlRequest = apiUrl + 'mascotas';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'nombre': nombre,
          'sexo': sexo,
          'estirilizacion': estirilizacion,
          'fecha_nacimiento': fechaNacimiento,
          'condicion_medica': condicionMedica,
          'microchip': microchip,
          'alimentos': alimentos,
          'personalidad': personalidad,
          'raza_id': raza,
          'usuario_rut': rut,
        }));
    return respuesta;
  }

  // LISTAR MASCOTAS POR RUT DEL USUARIO //
  Future<List<dynamic>> mascotaListar() async {
    var urlRequest = apiUrl + 'mascotas';
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

  Future<http.Response> mascotaEditar(
      int idRaza, String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'mascotas/$idRaza';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // BORRAR MASCOTA //
  Future<http.Response> mascotaBorrar(int id) async {
    var urlRequest = apiUrl + 'mascotas/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }
}
