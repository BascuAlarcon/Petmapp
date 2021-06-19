import 'dart:async';
// import 'dart:html';

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
import 'package:carousel_pro/carousel_pro.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];

  // final Location location = Location();
  String _addrees, _dateTime;

  SharedPreferences sharedPreferences;
  String email = '';
  String token = '';
  String name = '';
  String estado = '';
  String rut = '';
  String perfil = '';
  var listaDatos;

  Position currentePosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentePosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    print("Position:" +
        position.latitude.toString() +
        "/" +
        position.longitude.toString());

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
  }

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    checkLoginStatus();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {
          mostrarMarcador(context);
        },
        position: LatLng(-33.036523, -71.486873)));
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
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway')),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () => _navegarUsuarioPerfil(context),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://danbooru.donmai.us/data/sample/0f/ee/__kiryu_coco_hololive_drawn_by_beedrops__sample-0fee041361a8ad923821089770bddaca.jpg'),
                    ),
                  )),
            ]),

        /// MAPA ///
        ///
        ///
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 190.0, left: 32.0),
          child: Center(
            child: Icon(
              Icons.home_outlined,
              color: Colors.lightBlueAccent,
              size: 40.0,
            ),
          ),
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: puntoInicial,
          markers: Set.from(allMarkers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            locatePosition();
          },
        ),

        /// DRAWER ///
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(120, 139, 255, 1.0),
          ),
          child: Drawer(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(perfil),
                  accountEmail: new Text(name),
                ),
                new Divider(),
                ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    title: Text('Mi Perfil',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Raleway')),
                    onTap: () => _navegarUsuarioPerfil(context)),
                ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    title: Text('Razas',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Raleway')),
                    onTap: () => _navegarRazas(context)),
                ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    title: Text('Especies',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Raleway')),
                    onTap: () => _navegarEspecies(context)),
                ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    title: Text('Ver Publicaciones',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Raleway')),
                    onTap: () => _navegarPublicaciones(context)),
                estado == "2"
                    ? ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        title: Text('Cuidados',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Raleway')),
                        onTap: () {},
                      )
                    : ListTile(
                        title: Text('Cuidados',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: 'Raleway')),
                        onTap: () {},
                      ),
                perfil == "1"
                    ? ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        title: Text('Administrador',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Raleway')),
                        onTap: () {})
                    : Text(''),
                perfil == "1"
                    ? ListTile(
                        trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        title: Text('Ver Usuarios',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Raleway')),
                        onTap: () => _navegarListarUsuarios(context),
                      )
                    : Text(''),
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
                child:
                    Icon(Icons.home, color: Color.fromRGBO(120, 139, 255, 1.0)),
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
                child: Icon(Icons.add_alarm,
                    color: Color.fromRGBO(120, 139, 255, 1.0)),
              ),
              Container(
                child: Text(
                  '+',
                  style: TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                ),
              )
            ]),
            Column(children: <Widget>[
              Container(
                child: Icon(
                  Icons.landscape,
                  color: Color.fromRGBO(120, 139, 255, 1.0),
                ),
              ),
              Container(
                child: Text(
                  'Places',
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

  mostrarMarcador(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Ir"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("Alerta - Cuidados")),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height - 550,
            width: width - 100,
            child: Column(
              children: [
                SizedBox(
                    height: 150.0,
                    width: 300.0,
                    child: Carousel(
                      images: [
                        NetworkImage(
                            'https://danbooru.donmai.us/data/sample/9b/b3/__kiryu_coco_and_akai_haato_hololive_drawn_by_kaniq__sample-9bb34caaf59fab94d2e75d02c87aac02.jpg'),
                        NetworkImage(
                            'https://danbooru.donmai.us/data/sample/1b/dd/__kiryu_coco_hololive_drawn_by_sakuramochi_sakura_frappe__sample-1bdd038c296ec71644b980458071a57b.jpg'),
                        NetworkImage(
                            'https://danbooru.donmai.us/data/sample/10/39/__kiryu_coco_hololive_drawn_by_sakuramochi_sakura_frappe__sample-1039b4a3cf46c55dc127bafd7d2c80d3.jpg')
                      ],
                    )),
                Divider(),
                Text(
                    "Descripción: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "),
              ],
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
