import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class UsuarioProvider {
  var apiUrl = new UrlProvider().url();

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
      return json.decode(response.body);
    } else {
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
      print(response.body);
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // LISTAR USUARIOS //
  Future<List<dynamic>> getUsuarios() async {
    var urlRequest = apiUrl + 'auth/usuarios';
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

  // MOSTRAR USUARIO //
  Future<LinkedHashMap<String, dynamic>> mostrarUsuario(int rut) async {
    var urlRequest = apiUrl + 'auth/usuarios/$rut';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  // EDITAR USUARIO //
  Future<http.Response> perfilEditar(String rut, String email, String name,
      String sexo, String fechaNacimiento, String foto, String numero) async {
    var rutEdit = int.tryParse(rut);
    var urlRequest = apiUrl + 'auth/usuarios/$rutEdit';
    var respuesta = await http.put(Uri.parse(urlRequest),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'name': name,
          'sexo': sexo,
          'fecha_nacimiento': fechaNacimiento,
          'foto': foto,
          'numero_telefonico': numero
        }));
    return respuesta;
  }

// OBTENER PUBLICACIONES //
  Future<List<dynamic>> publicacionListar(token) async {
    var urlRequest = apiUrl + 'auth/me/publicaciones';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.statusCode);
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

// OBTENER PETICIONES DE DETERMINADA PUBLICACION //
  Future<LinkedHashMap<String, dynamic>> peticionListar(id) async {
    var urlRequest = apiUrl + 'publicaciones/$id/peticiones';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return new LinkedHashMap<String, dynamic>();
      }
    } else {
      return new LinkedHashMap<String, dynamic>();
    }
  }

  Future<List<dynamic>> peticionListar2(id) async {
    var urlRequest = apiUrl + 'publicaciones/$id/peticioness'; // peticioness //
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
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

  // OBTENER HOGARES //
  Future<List<dynamic>> hogarListar(token) async {
    var urlRequest = apiUrl + 'auth/me/hogares';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.statusCode);
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

  // OBTENER HOGARES //
  Future<List<dynamic>> getPeticiones(token) async {
    var urlRequest = apiUrl + 'auth/me/peticiones';
    var response = await http.get(
      Uri.parse(urlRequest),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.statusCode);
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

  // CALCULAR EDAD DE USUARIO  //
  // Future<String> calcularEdad(DateTime fechaNacimiento) async {
  //   final fechaActual = new DateTime.now();
  //   var fechaFinal = fechaActual.difference(fechaNacimiento);
  //   return "";
  // }
}
