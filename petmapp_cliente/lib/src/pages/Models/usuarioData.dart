import 'package:petmapp_cliente/src/pages/Models/usuario.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:petmapp_cliente/src/providers/url_provider.dart';

class UsuariosApi {
  static Future<List<Usuario>> getUsuarios(String query) async {
    var apiUrl = new UrlProvider().url();
    var urlRequest = apiUrl + 'auth/usuarios';
    var response = await http.get(Uri.parse(urlRequest));
    if (response.statusCode == 200) {
      final List usuarios = json.decode(response.body);

      return usuarios.map((json) => Usuario.fromJson(json)).where((usuario) {
        final correoLower = usuario.correo.toLowerCase();
        final searchLower = query.toLowerCase();
        return correoLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
