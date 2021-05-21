import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetmappProvider {
  // PARA DISPOSISITO VIRTUAL USAR 10.0.2.2
  // final apiUrl = 'http://10.0.2.2:8000/api/';
  // DISPOSITIVO FISICO USAR LA IP DE NUESTRA COMPUTADORA
  final apiUrl = 'http://192.168.0.10:8000/api/';

  // RAZAS //

  // OBTENER RAZAS //
  Future<List<dynamic>> getRazas() {
    var urlRequest = apiUrl + 'razas';
    return _getData(urlRequest);
  }

  // METODO PRIVADO //
  Future<List<dynamic>> _getData(String url) async {
    var response = await http.get(Uri.parse(url));
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

  // AGREGAR RAZAS //
  Future<http.Response> razaAgregar(String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'razas';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // EDITAR RAZAS //
  Future<http.Response> razaEditar(
      int idRaza, String nombre, String descripcion) async {
    var urlRequest = apiUrl + 'razas/$idRaza';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, String>{'nombre': nombre, 'descripcion': descripcion}));
    return respuesta;
  }

  // BORRAR RAZAS//
  Future<http.Response> razasBorrar(int id) async {
    var urlRequest = apiUrl + 'razas/' + id.toString();
    return await http.delete(Uri.parse(urlRequest));
  }

  // ENTREGAR DATOS PARA EL FORMULARIO DE EDITAR //
  Future<LinkedHashMap<String, dynamic>> getRaza(int idRaza) async {
    var urlRequest = apiUrl + 'razas/$idRaza';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // LISTAR MASCOTAS POR RAZAS //
  Future<LinkedHashMap<String, dynamic>> razasMascotas(int idRaza) async {
    var urlRequest = apiUrl + 'razas/$idRaza/mascotas';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // USUARIOS //

  // REGISTRAR USUARIO //
  Future<LinkedHashMap<String, dynamic>> registrar(
      String rut, String email, String password, String nombre) async {
    var urlRequest = apiUrl + 'auth/register';
    var response = await http.post(Uri.parse(urlRequest), body: {
      "rut": rut,
      "email": email,
      "password": password,
      "name": nombre
    });
    if (response.statusCode == 200) {
      print('Funciono');
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // LOGIN USUARIO //
  Future<LinkedHashMap<String, dynamic>> login(
      String email, String password) async {
    var urlRequest = apiUrl + 'auth/login';
    var response = await http.post(Uri.parse(urlRequest),
        body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // LISTAR USUARIOS //
  Future<List<dynamic>> getUsuarios() async {
    var urlRequest = apiUrl + 'auth/index';
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

  // MASCOTAS //

  // AGREGAR MASCOTA //
  Future<http.Response> mascotaAgregar(
      String rut, String nombre, String sexo, String raza) async {
    var urlRequest = apiUrl + 'mascotas';
    var respuesta = await http.post(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'nombre': nombre,
          'sexo': sexo,
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
