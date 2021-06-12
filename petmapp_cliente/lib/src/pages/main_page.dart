import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_listar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_perfil_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
  SharedPreferences sharedPreferences;
  String email = '';
  String token = '';
  String name = '';
  String estado = '';
  String rut = '';
  String perfil = '';
  var listaDatos;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // INITIAL POINT //
    final CameraPosition puntoInicial = CameraPosition(
      target: LatLng(-33.036523, -71.486873),
      zoom: 16,
    );

    // SCAFFOLD //
    return Scaffold(
        appBar: AppBar(
            title: Text("PetmApp", style: TextStyle(color: Colors.white)),
            backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    child: Text('SL'),
                    backgroundImage: NetworkImage(
                        'https://danbooru.donmai.us/data/sample/1f/bf/__saigyouji_yuyuko_touhou_drawn_by_shiranui_wasuresateraito__sample-1fbf785207a8d70f72f49f1a33ef26e0.jpg'),
                  )),
            ]),

        /// MAPA ///
        body: GoogleMap(
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: puntoInicial,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),

        /// DRAWER ///
        drawer: Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(perfil),
                accountEmail: new Text(name),
              ),
              new Divider(),
              ListTile(
                  title: Text('Mi Perfil'),
                  onTap: () => _navegarUsuarioPerfil(context)),
              ListTile(
                  title: Text('Razas'), onTap: () => _navegarRazas(context)),
              ListTile(
                  title: Text('Especies'),
                  onTap: () => _navegarEspecies(context)),
              ListTile(
                  title: Text('Ver Publicaciones'),
                  onTap: () => _navegarPublicaciones(context)),
              estado == "2"
                  ? ListTile(
                      title: Text('Cuidado'),
                      onTap: () {},
                    )
                  : Text(''),
              perfil == "1"
                  ? ListTile(title: Text('Administrador'), onTap: () {})
                  : Text(''),
              perfil == "1"
                  ? ListTile(
                      title: Text('Ver Usuarios'),
                      onTap: () => _navegarListarUsuarios(context),
                    )
                  : Text(''),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Column(children: <Widget>[
              Container(
                child: Icon(Icons.home),
              ),
              Container(
                child: Text('Home'),
              )
            ]),
            Icon(Icons.list, size: 30),
            Icon(Icons.compare_arrows, size: 30),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ));
  }

  void _navegarUsuarioPerfil(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => UsuarioPerfilPage(
              rutUsuario: int.tryParse(rut),
            ));
    Navigator.push(context, route);
  }

  void _navegarRazas(BuildContext context) {
    var route = new MaterialPageRoute(builder: (context) => RazaListarPage());
    Navigator.push(context, route);
  }

  void _navegarPublicaciones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => PublicacionListarPage());
    Navigator.push(context, route);
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
      perfil = sharedPreferencess.getStringList('usuario')[3];
      token = sharedPreferencess.getStringList('usuario')[4];
      estado = sharedPreferencess.getStringList('usuario')[5];
    });
  }
}

void _navegarCuidado(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => EspecieListarPage());
  Navigator.push(context, route);
}

void _navegarEspecies(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => EspecieListarPage());
  Navigator.push(context, route);
}

_navegarListarUsuarios(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => UsuarioListarPage());
  Navigator.push(context, route);
}
