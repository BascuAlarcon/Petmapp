import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/hogares_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_perfil_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/mis_publicaciones_usuario_listar.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String perfil = '';
  String token = '';
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
            title: Text("PetmApp",
                style: TextStyle(color: Colors.white, fontFamily: "Raleway")),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    // child: Text('SL'),
                    backgroundImage: NetworkImage(
                        'https://e7.pngegg.com/pngimages/604/701/png-clipart-puppy-kitten-dachshund-dog-breed-f-minus-pigs-shirt-mammal-carnivoran.png'),
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
        drawer: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Color.fromRGBO(120, 139, 255, 1.0)),
          child: Drawer(
            child: new ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Raleway'),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://t4.ftcdn.net/jpg/04/29/99/81/360_F_429998130_UfBO2KQf745euFhOnETvamzPPgPuyHuI.jpg"),
                          fit: BoxFit.cover)),
                ),
                // new UserAccountsDrawerHeader(
                //   accountName: new Text(perfil),
                //   accountEmail: new Text(name),
                // ),
                new Divider(),
                ListTile(
                    title: Text(
                      'Mi Perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _navegarUsuarioPerfil(context)),
                ListTile(
                    title: Text(
                      'Razas',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _navegarRazas(context)),
                ListTile(
                    title: Text(
                      'Especies',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _navegarRazas(context)),
                ListTile(
                    title: Text(
                      'Ver Publicaciones',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _navegarPublicaciones(context)),
                perfil == "1"
                    ? ListTile(
                        title: Text(
                          'Ver Usuarios',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => _navegarListarUsuarios(context),
                      )
                    : Text(''),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    margin: EdgeInsets.only(top: 15.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white12))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        sharedPreferences.clear();
                        sharedPreferences.commit();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text("Cerrar Sesión",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Raleway')),
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Column(children: <Widget>[
              Container(
                child: Icon(
                  Icons.home,
                  color: Color.fromRGBO(120, 139, 255, 1.0),
                ),
              ),
              Container(
                child: Text(
                  'Home',
                  style: TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                ),
              )
            ]),
            Column(children: <Widget>[
              Container(
                child: Icon(
                  Icons.add_alert,
                  color: Color.fromRGBO(120, 139, 255, 1.0),
                ),
              ),
              Container(
                child: Text(
                  'Alerta',
                  style: TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                ),
              )
            ]),
            Column(children: <Widget>[
              Container(
                child: Icon(
                  Icons.photo_library,
                  color: Color.fromRGBO(120, 139, 255, 1.0),
                ),
              ),
              Container(
                child: Text(
                  'Lugar',
                  style: TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                ),
              )
            ]),
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
    });
  }
}

_navegarListarUsuarios(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => UsuarioListarPage());
  Navigator.push(context, route);
}
