import 'package:shared_preferences/shared_preferences.dart';

String rut, email, name, perfil, token, estado;

@override
void initState() {
  cargarDatosUsuario();
}

class DatosUsuario {
  static List<String> datos = [rut, email, name, perfil, token, estado];
}

List<String> datos = [rut, email, name, perfil, token, estado];

Future<void> cargarDatosUsuario() async {
  SharedPreferences sharedPreferencess = await SharedPreferences.getInstance();
  rut = sharedPreferencess.getStringList('usuario')[0];
  email = sharedPreferencess.getStringList('usuario')[1];
  name = sharedPreferencess.getStringList('usuario')[2];
  perfil = sharedPreferencess.getStringList('usuario')[3];
  token = sharedPreferencess.getStringList('usuario')[4];
  estado = sharedPreferencess.getStringList('usuario')[5];
}
