import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class PeticionProvider {
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
  // agregar peticion //

  // FALTA AGREGAR PRECIO TOTAL (CALCULADO A PARTIR DEL CAMPO 'TARIFA' DE LA TABLA PUBLICACIÓN Y LOS DÍAS QUE DURARÁ EL CUIDADO //
  Future<http.Response> peticionAgregar(
      String descripcion,
      String fecha_inicio,
      String fecha_fin,
      List mascotas,
      String precioTotal,
      String usuario_rut,
      String publicacion_id) async {
    var urlRequest = apiUrl + 'peticiones';
    if (mascotas.length == 1) {
      var respuesta = await http.post(Uri.parse(urlRequest),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'usuario_rut': usuario_rut,
            'publicacion_id': publicacion_id,
            'precio_total': precioTotal,
            'boleta': precioTotal,
            'descripcion': descripcion,
            'mascota1': mascotas[0].id.toString()
          }));
      print(respuesta);
      return respuesta;
    }
    if (mascotas.length == 2) {
      var respuesta = await http.post(Uri.parse(urlRequest),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'usuario_rut': usuario_rut,
            'publicacion_id': publicacion_id,
            'precio_total': precioTotal,
            'boleta': precioTotal,
            'descripcion': descripcion,
            'mascota1': mascotas[0].id.toString(),
            'mascota2': mascotas[1].id.toString()
          }));
      print(respuesta);
      return respuesta;
    }
    if (mascotas.length == 3) {
      var respuesta = await http.post(Uri.parse(urlRequest),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'usuario_rut': usuario_rut,
            'publicacion_id': publicacion_id,
            'precio_total': precioTotal,
            'boleta': precioTotal,
            'descripcion': descripcion,
            'mascota1': mascotas[0].id.toString(),
            'mascota2': mascotas[1].id.toString(),
            'mascota3': mascotas[2].id.toString()
          }));
      print(respuesta);
      return respuesta;
    }
    if (mascotas.length == 4) {
      var respuesta = await http.post(Uri.parse(urlRequest),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'usuario_rut': usuario_rut,
            'publicacion_id': publicacion_id,
            'precio_total': precioTotal,
            'boleta': precioTotal,
            'descripcion': descripcion,
            'mascota1': mascotas[0].id.toString(),
            'mascota2': mascotas[1].id.toString(),
            'mascota3': mascotas[2].id.toString(),
            'mascota4': mascotas[3].id.toString()
          }));
      print(respuesta);
      return respuesta;
    }
    if (mascotas.length == 5) {
      var respuesta = await http.post(Uri.parse(urlRequest),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin,
            'usuario_rut': usuario_rut,
            'publicacion_id': publicacion_id,
            'precio_total': precioTotal,
            'boleta': precioTotal,
            'descripcion': descripcion,
            'mascota1': mascotas[0].id.toString(),
            'mascota2': mascotas[1].id.toString(),
            'mascota3': mascotas[2].id.toString(),
            'mascota4': mascotas[3].id.toString(),
            'mascota5': mascotas[4].id.toString()
          }));
      print(respuesta);
      return respuesta;
    }
  }

  // EDITAR peticiones //
  Future<http.Response> peticionEditar(int idpeticion, String descripcion,
      String fecha_inicio, String fecha_fin) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'fecha_inicio': fecha_inicio,
          'fecha_fin': fecha_fin,
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
    var urlRequest = apiUrl + 'peticiones/$idpeticion/mascotas';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // RESPUESTA PETICION //
  // TIENE QUE SER CON METODO POST //
  Future<http.Response> peticionRespuesta(int idpeticion, String estado) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion/respuesta';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'estado': estado}));
    return respuesta;
  }

  Future<http.Response> peticionComentario(
      int idpeticion, String comentario, String nota) async {
    var urlRequest = apiUrl + 'peticiones/$idpeticion/comentario';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'comentario': comentario, 'nota': nota}));
    return respuesta;
  }

  Future<http.Response> peticionTerminada(String id, String estado) async {
    int idpeticion = int.tryParse(id);
    var urlRequest = apiUrl + 'peticiones/$idpeticion/termino';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'estado': estado}));
    return respuesta;
  }

  Future<LinkedHashMap<String, dynamic>> mascotasPeticion(
      int idPeticion) async {
    var urlRequest = apiUrl + 'peticiones/$idPeticion/mascotas';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }
}
