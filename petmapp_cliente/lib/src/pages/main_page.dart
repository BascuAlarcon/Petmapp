import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_listar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_perfil_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_page.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<Marker> allMarkers = [];

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> addingMarker = [];
  BitmapDescriptor mapMarker;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/home.png');
  }

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

  Position _position;
  Address _direccion;
  Position currentePosition;
  StreamSubscription<Position> _streamSubscription;
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

  ScrollController scrollController;

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
// Controllers //
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController tarifaCtrl = new TextEditingController();
  TextEditingController coordenadasCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    publicacionListarr(context);
    checkLoginStatus();
    setCustomMarker();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        icon: mapMarker,
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
    return Stack(children: <Widget>[
      Scaffold(
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
            padding: const EdgeInsets.only(top: 670.0, left: 32.0),
            child: Center(
                child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                panelController.expand();
              },
            )),
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
            onTap: _handletap,
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
                  child: Icon(Icons.home,
                      color: Color.fromRGBO(120, 139, 255, 1.0)),
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
          )),
      SlidingUpPanelWidget(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: ShapeDecoration(
            color: Colors.white,
            shadows: [
              BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                  color: const Color(0x11000000))
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.menu,
                      size: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                      ),
                    ),
                    Text(
                      'Publicar',
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                height: 50.0,
              ),
              Divider(
                height: 0.5,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: coordenadasCtrl,
                  decoration: InputDecoration(
                      labelText: 'Coordenadas',
                      hintText: 'Coordenadas de la publicación',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descripcionCtrl,
                  decoration: InputDecoration(
                      labelText: 'Descripcion',
                      hintText: 'Descripcion de la publicacion',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tarifaCtrl,
                  decoration: InputDecoration(
                      labelText: 'Tarifa',
                      hintText: 'Tarifa',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Agregar publicacion'),
                  onPressed: () => _publicacionAgregar(context),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () => _navegarCancelar(context),
                ),
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
        controlHeight: 50.0,
        anchor: 0.4,
        panelController: panelController,
        onTap: () {
          ///Customize the processing logic
          if (SlidingUpPanelStatus.expanded == panelController.status) {
            panelController.collapse();
          } else {
            panelController.expand();
          }
        },
        enableOnTap: true, //Enable the onTap callback for control bar.
        dragDown: (details) {
          print('dragDown');
        },
        dragStart: (details) {
          print('dragStart');
        },
        dragCancel: () {
          print('dragCancel');
        },
        dragUpdate: (details) {
          print(
              'dragUpdate,${panelController.status == SlidingUpPanelStatus.dragging ? 'dragging' : ''}');
        },
        dragEnd: (details) {
          print('dragEnd');
        },
      ),
    ]);
  }

  void _publicacionAgregar(BuildContext context) {
    var provider = new PublicacionProvider();
    provider.publicacionAgregar(coordenadasCtrl.text, descripcionCtrl.text,
        tarifaCtrl.text, rut); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _handletap(LatLng tappedPoint) {
    // var alex = coordenadasCtrl.text.split("(");
    // var alex2 = alex[1].split(")");
    // coordenadasCtrl.text = alex2[0];
    final coordinates =
        new Coordinates(tappedPoint.latitude, tappedPoint.longitude);
    // convertirCoordenadasADireccion(coordinates)
    //     .then((value) => _direccion = value);
    var numero = allMarkers.length;
    print("allMarkers: " + allMarkers.toString());
    var cod = true;
    // coordenadasCtrl.text = _direccion.addressLine;
    coordenadasCtrl.text = coordinates.latitude.toString() +
        ";" +
        coordinates.longitude.toString();
    print("numero:" + numero.toString());
    setState(() {
      print("Estoy acá");
      if (numero > 1) {
        print("Entró acáa");
        print("tappedPoint:" + tappedPoint.toString());
        allMarkers.removeAt(numero - 1);
        allMarkers.add(Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            draggable: true,
            onTap: () {
              print("Apretaste el coso!!!!!1");
              allMarkers.removeAt(numero - 1);
              panelController.hide();
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            }));
      } else {
        print("Entro por el otro lado ");
        allMarkers.add(Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            draggable: true,
            onTap: () {
              print("Apretaste el coso!!2");
              allMarkers.removeAt(numero - 1);
              panelController.hide();
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            }));
      }
      //addingMarker = [];
    });
  }

  Future<Address> convertirCoordenadasADireccion(
      Coordinates coordinates) async {
    var direccion =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return direccion.first;
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
            child: SingleChildScrollView(
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
                              'https://danbooru.donmai.us/data/sample/1b/dd/__kiryu_coco_hololive_drawn_by_sakuramochi_sakura_frappe__sample-1bdd038c296ec71644b980458071a57b.jpg')
                        ],
                      )),
                  Divider(),
                  Text(
                      "Descripción: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "),
                ],
              ),
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

  void _navegarpublicacionesAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => PublicacionesAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
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

Future<List<dynamic>> publicacionListarr(context) async {
  var provider = new PublicacionProvider();
  var listaPublicaciones = await provider.publicacionListar();

  mostrarMarcador2(BuildContext context, String descripcion, String tarifa) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Ir"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text(descripcion)),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height - 550,
            width: width - 100,
            child: SingleChildScrollView(
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
                              'https://danbooru.donmai.us/data/sample/1b/dd/__kiryu_coco_hololive_drawn_by_sakuramochi_sakura_frappe__sample-1bdd038c296ec71644b980458071a57b.jpg')
                        ],
                      )),
                  Text(tarifa),
                  Divider(),
                  Text(
                      "Descripción: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "),
                ],
              ),
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

  for (int i = 0; i < listaPublicaciones.length; i++) {
    allMarkers.add(
      Marker(
        markerId: MarkerId(listaPublicaciones[i]["descripcion"]),
        draggable: false,
        onTap: () {
          print("gol");
          mostrarMarcador2(context, listaPublicaciones[i]["descripcion"],
              listaPublicaciones[i]["tarifa"].toString());
        },
        // icon: mapMarker,
        position: LatLng(double.parse(listaPublicaciones[i]["latitude"]),
            double.parse(listaPublicaciones[i]["longitude"])),
      ),
    );
  }
}
