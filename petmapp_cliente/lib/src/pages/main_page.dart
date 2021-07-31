import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:html';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_listar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones/ubicaciones_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuenta/usuario_mi_perfil_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuidado_page.dart';
// import 'package:petmapp_cliente/src/pages/usuario/usuario_perfil_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_page.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/comentarios_alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

import 'alertas/alertas_listar_page.dart';
import 'comentarios_alertas/coment_alertas_editar_page.dart';
import 'negocios/negocios_listar_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<Marker> allMarkers = [];
int globalIdMarker = 1;
var itemComentarios = [];
String idAlertaSeleccionado;

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> addingMarker = [];
  BitmapDescriptor mapMarker;

  /* void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/home.png');
  } */

  // final Location location = Location();
  String _addrees, _dateTime;
  var _tipos = <DropdownMenuItem>[];
  //Variables Cargar Hogares
  var _hogares = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var _hogar = '';

  //Variable seleccion de menú
  var selectHome = true;
  var selectAlerta = false;

  SharedPreferences sharedPreferences;
  String email = '';
  String token = '';
  String name = '';
  String estado = '';
  String rut = '';
  String perfil = '';
  bool habilitado = false;
  var listaDatos;
  int i = 0;
  Position _position;
  Address _direccion;
  Position currentePosition;
  StreamSubscription<Position> _streamSubscription;
  var geoLocator = Geolocator();

// DATA USUARIO
  var tipoUsuario;
  var idData;
  var idDataPublicacion;
  var _ultimoDia = false;
  var rutOtro;
  var estadoPeticion;
  var nota;
  var idHogar;
  var mascotas;

//
  bool servicioFinalizado;

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
  TextEditingController tituloCtrl = new TextEditingController();
  TextEditingController comentarioAlertaCtrl = new TextEditingController();

  TextEditingController tituloAlertCtrl = new TextEditingController();
  TextEditingController descripcionAlertCtrl = new TextEditingController();
  TextEditingController direccionAlertCtrl = new TextEditingController();
  TextEditingController latitudeAlertCtrl = new TextEditingController();
  TextEditingController longitudeAlertCtrl = new TextEditingController();

//Fotos Alerta
  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();
  var alerta = '';
  var _alertaSeleccionado;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    publicacionListarr(context);
    alertasListar(context);
    checkLoginStatus();
    _cargarTiposAlertas();
    /* setCustomMarker(); */
    /* allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        icon: mapMarker,
        onTap: () {
          mostrarMarcador(context);
        },
        position: LatLng(-33.036523, -71.486873)) */
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                getSlider(i);
                panelController.anchor();
              });
            },
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
                  // ListTile(
                  //     trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  //     title: Text('Mi Perfil',
                  //         style: TextStyle(
                  //             color: Colors.white, fontFamily: 'Raleway')),
                  //     onTap: () => _navegarUsuarioPerfil(context)),
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
                  servicioFinalizado == false
                      ? ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                          title: Text('Cuidados',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Raleway')),
                          onTap: () => _navegarCuidado(context),
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
                  perfil == "1"
                      ? ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                          title: Text('Negocios',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Raleway')),
                          onTap: () => _navegarNegocios(context),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: CurvedNavigationBar(
              onTap: (index) {
                i = index;
                print("valor i: " + i.toString());
              },
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
                      style:
                          TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
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
                      style:
                          TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                  )
                ]),
                // Column(children: <Widget>[
                //   Container(
                //     child: Icon(
                //       Icons.landscape,
                //       color: Color.fromRGBO(120, 139, 255, 1.0),
                //     ),
                //   ),
                //   Container(
                //     child: Text(
                //       'Places',
                //       style:
                //           TextStyle(color: Color.fromRGBO(120, 139, 255, 1.0)),
                //     ),
                //   )
                // ]),
              ],
            ),
          )),
      getSlider(i),
    ]);
  }

  void _publicacionAgregar(BuildContext context) {
    var provider = new PublicacionProvider();
    provider.publicacionAgregar(
      tituloCtrl.text,
      descripcionCtrl.text,
      tarifaCtrl.text,
      rut,
    ); // usamos un controller //
    panelController.hide();
    // Navigator.pop(context);
  }

  void _AlertasAgregar(BuildContext context) {
    var provider = new AlertaProvider();
    provider.alertaAgregar(
        tituloAlertCtrl.text,
        rut,
        _alertaSeleccionado.toString(),
        foto,
        descripcionAlertCtrl.text,
        direccionAlertCtrl.text,
        latitudeAlertCtrl.text,
        longitudeAlertCtrl.text);
    panelController.hide();
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarTiposAlertas() async {
    var provider = new TipoAlertaProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(
            DropdownMenuItem(child: Text(tipo['nombre']), value: tipo['id']));
      });
    });
  }

  _handletap(LatLng tappedPoint) {
    // var alex = tituloCtrl.text.split("(");
    // var alex2 = alex[1].split(")");
    // tituloCtrl.text = alex2[0];
    final coordinates =
        new Coordinates(tappedPoint.latitude, tappedPoint.longitude);
    convertirCoordenadasADireccion(coordinates)
        .then((value) => _direccion = value);
    var numero = allMarkers.length;
    print("allMarkers: " + allMarkers.toString());
    direccionAlertCtrl.text = _direccion.addressLine;
    latitudeAlertCtrl.text = coordinates.latitude.toString();
    longitudeAlertCtrl.text = coordinates.longitude.toString();
    // tituloCtrl.text = coordinates.latitude.toString() +
    //     ";" +
    //     coordinates.longitude.toString();
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

  void _navegarRazas(BuildContext context) {
    var route = new MaterialPageRoute(builder: (context) => RazaListarPage());
    Navigator.push(context, route);
  }

  // void _navegarPublicaciones(BuildContext context) {
  //   var route =
  //       new MaterialPageRoute(builder: (context) => PublicacionListarPage());
  //   Navigator.push(context, route);
  // }

  void _navegarpublicacionesAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => PublicacionesAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  // void _navegarUsuarioPerfil(BuildContext context) {
  //   var route = new MaterialPageRoute(
  //       builder: (context) => UsuarioPerfilPage(
  //             rutUsuario: int.tryParse(rut),
  //           ));
  //   Navigator.push(context, route).then((value) {
  //     setState(() {
  //       comprobarDatos();
  //       cargarDatosUsuario();
  //     });
  //   });
  // }

  // TRAER DATOS DE SHARED PREFERENCES //
  // Future<void> cargarDatosUsuario() async {
  //   SharedPreferences sharedPreferencess =
  //       await SharedPreferences.getInstance();
  //   setState(() {
  //     rut = sharedPreferencess.getStringList('usuario')[0];
  //     email = sharedPreferencess.getStringList('usuario')[1];
  //     name = sharedPreferencess.getStringList('usuario')[2];
  //     perfil = sharedPreferencess.getStringList('usuario')[3];
  //     token = sharedPreferencess.getStringList('usuario')[4];
  //     estado = sharedPreferencess.getStringList('usuario')[5];
  //   });
  //   var provider = UsuarioProvider();
  //   var usuario = await provider.mostrarUsuario(int.tryParse(rut));
  //   var hogarProvider = HogarProvider();
  //   var hogares = await hogarProvider.hogarListar();
  //   for (var hogar in hogares) {
  //     if (hogar['usuario_rut'].toString() == rut) {
  //       if (usuario['fechaNacimiento'] != null ||
  //           usuario['sexo'] != null ||
  //           usuario['numero_telefonico'] != null) {
  //         habilitado = true;
  //       }
  //     }
  //   }
  //   //Cargar hogares
  //   _cargarHogares() async {
  //     var provider = new HogarProvider();
  //     var hogares = await provider.hogarListar();
  //     hogares.forEach((hogar) {
  //       if (hogar['usuario_rut'].toString() == rut.toString()) {
  //         setState(() {
  //           _hogares.add(DropdownMenuItem(
  //               child: Text(hogar['direccion']), value: hogar['id']));
  //         });
  //       }
  //     });
  //   }

  //   _cargarHogares();
  // }

  _mostrarAviso(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Es necesario completar los siguientes datos: '),
            content: Text(
                'Hogares \n Información personal \n\n Porfavor, complete los datos restantes en su perfil'),
            actions: [
              MaterialButton(
                  child: Text('Acceptar',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> comprobarDatos() async {
    var provider = UsuarioProvider();
    var usuario = await provider.mostrarUsuario(int.tryParse(rut));
    if (usuario['fechaNacimiento'] != null ||
        usuario['sexo'] != null ||
        usuario['numero_telefonico'] != null) {
      habilitado = true;
    } else {
      habilitado = false;
    }
  }

  Widget getSlider(int index) {
    print("hola" + index.toString());
    if (index == 0) {
      return SlidingUpPanelWidget(
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
                      'Crear Publicación',
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
                  controller: tituloCtrl,
                  decoration: InputDecoration(
                      labelText: 'Título',
                      hintText: 'Título de la publicación',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value: _valorSeleccionado,
                  items: _hogares,
                  hint: Text('Hogar'),
                  onChanged: (value) {
                    setState(() {
                      _hogar = value.toString();
                      _valorSeleccionado = value;
                    });
                  },
                  validator: (valor) {
                    if (valor == null) {
                      return 'Seleccione un valor';
                    }
                    return null;
                  },
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: ElevatedButton(
                    child: Text('Agregar publicacion'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                    onPressed: () => _publicacionAgregar(context),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: ElevatedButton(
                    child: Text('Cancelar'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(199, 199, 183, 1.0)),
                    ),
                    onPressed: () => _navegarCancelar(context),
                  ),
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
        controlHeight: 0.58,
        anchor: 0.63,
        panelController: panelController,
        onTap: () {
          ///Customize the processing logic
          if (SlidingUpPanelStatus.expanded == panelController.status) {
            panelController.collapse();
          } else {
            panelController.anchor();
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
      );
    } else {
      return SlidingUpPanelWidget(
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
                      'Crear Alerta',
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
              Row(
                children: [
                  IconButton(
                    icon: new Icon(
                      Icons.add_a_photo_rounded,
                      color: Colors.black,
                    ),
                    highlightColor: Colors.pink,
                    onPressed: () {
                      tomarFoto(ImageSource.camera);
                    },
                  ),
                  IconButton(
                    icon: new Icon(
                      Icons.folder_special_outlined,
                      color: Colors.black,
                    ),
                    highlightColor: Colors.pink,
                    onPressed: () {
                      tomarFoto(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 400.0,
                height: 120.0,
                child: FadeInImage(
                    image: _imagefile == null
                        ? NetworkImage(
                            'https://danbooru.donmai.us/data/sample/9e/66/__azura_cecillia_and_miyu_ottavia_nijisanji_and_2_more_drawn_by_angon623__sample-9e66517bd366863d5d1a5dc2dbd33b91.jpg')
                        : FileImage(File(_imagefile.path)),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tituloAlertCtrl,
                  decoration: InputDecoration(
                      labelText: 'Título',
                      hintText: 'Título de la alerta',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value: _alertaSeleccionado,
                  items: _tipos,
                  hint: Text('Tipo Alerta'),
                  onChanged: (value) {
                    setState(() {
                      alerta = value.toString();
                      _alertaSeleccionado = value;
                    });
                  },
                  validator: (valor) {
                    if (valor == null) {
                      return 'Seleccione un valor';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descripcionAlertCtrl,
                  decoration: InputDecoration(
                      labelText: 'Descripcion',
                      hintText: 'Descripcion de la publicacion',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: direccionAlertCtrl,
                  decoration: InputDecoration(
                      labelText: 'Dirección',
                      hintText: 'Tarifa',
                      suffixIcon: Icon(Icons.flag)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: ElevatedButton(
                    child: Text('Agregar Alerta'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                    onPressed: () => _AlertasAgregar(context),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: ElevatedButton(
                    child: Text('Cancelar'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(199, 199, 183, 1.0)),
                    ),
                    onPressed: () => _navegarCancelar(context),
                  ),
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
        controlHeight: 0.58,
        anchor: 0.58,
        panelController: panelController,
        onTap: () {
          ///Customize the processing logic
          if (SlidingUpPanelStatus.expanded == panelController.status) {
            panelController.collapse();
          } else {
            panelController.anchor();
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
      );
    }
  }

  void tomarFoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedFile;
      _imagefile == null ? null : foto = _imagefile.path;
    });
  }

  // Mostrar marcadores Publicaciones
  Future<List<dynamic>> publicacionListarr(context) async {
    var provider = new PublicacionProvider();
    var listaPublicaciones = await provider.publicacionListar();

    mostrarMarcadorPublicacion(BuildContext context, String titulo,
        String descripcion, String tarifa) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Solicitar"),
        onPressed: () {},
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Center(child: Text(titulo)),
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
                    Text("\$" + tarifa),
                    Divider(),
                    Text(descripcion),
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
      var provider = HogarProvider();
      var hogares = await provider.hogarListar();
      for (var hogar in hogares) {
        if (hogar['id'] == listaPublicaciones[i]['hogar_id']) {
          allMarkers.add(
            Marker(
              markerId: MarkerId(globalIdMarker.toString()),
              draggable: false,
              onTap: () {
                print(hogar['latitud' + '\n' + hogar['longitud']]);
                mostrarMarcadorPublicacion(
                    context,
                    listaPublicaciones[i]["titulo"],
                    listaPublicaciones[i]["descripcion"],
                    listaPublicaciones[i]["tarifa"].toString());
              },
              // icon: mapMarker,
              position: LatLng(double.parse(hogar['latitud']),
                  double.parse(hogar['longitud'])),
            ),
          );
          globalIdMarker++;
        }
      }
    }
  }

  //Mostrar Marcadores ALertas
  Future<List<dynamic>> alertasListar(context) async {
    var provider = new AlertaProvider();
    mostrarMarcadorAlerta(BuildContext context, String titulo,
        String descripcion, String idAlerta) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("Publicar"),
        onPressed: () {},
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Center(child: Text(titulo)),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: height - 450,
              width: width - 100,
              child: Column(
                children: [
                  SingleChildScrollView(
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
                        Text(descripcion),
                        Divider(),
                        Container(
                          child: SingleChildScrollView(
                              child: Column(
                                  children: itemComentarios.map((comentario) {
                            return Text(comentario);
                          }).toList())),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // okButton,
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

    var alertas = await provider.alertaListar();
    for (int i = 0; i < alertas.length; i++) {
      allMarkers.add(
        Marker(
          // markerId: MarkerId(alertas[i]["descripcion"]),
          markerId: MarkerId(globalIdMarker.toString()),

          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          onTap: () {
            idAlertaSeleccionado = alertas[i]["id"].toString();
            mostrarMarcadorAlerta(context, alertas[i]["titulo"],
                alertas[i]["descripcion"], idAlertaSeleccionado);
          },
          // icon: mapMarker,
          position: LatLng(double.parse(alertas[i]['latitud']),
              double.parse(alertas[i]['longitud'])),
        ),
      );
      globalIdMarker++;
    }
  }

// 557
  void _navegarCuidado(BuildContext context) {
    _traerData();
    var route = new MaterialPageRoute(
        builder: (context) => CuidadoPage(
              widData: idData,
              wrutUsuario: rutOtro,
              wtipoUsuario: tipoUsuario,
              wultimoDia: _ultimoDia,
              westado: estadoPeticion,
              widDataPublicacion: idDataPublicacion,
              wnota: nota,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {
        _traerData();
        if (nota != null || nota != 11) {
          servicioFinalizado = true;
        }
      });
    });
  }

// 605
  void _navegarPublicaciones(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => PublicacionListarPage(
              idPublicacion: idDataPublicacion,
            ));
    Navigator.push(context, route);
  }

// 622
  void _navegarUsuarioPerfil(BuildContext context) {
    _traerData();
    var route = new MaterialPageRoute(
        builder: (context) => UsuarioPerfilPage(
              rutUsuario: int.tryParse(rut),
              widDataPeticion: idData,
              wrutOtro: rutOtro,
              wtipoUsuario: tipoUsuario,
              wultimoDia: _ultimoDia,
              westado: estadoPeticion,
              widDataPublicacion: idDataPublicacion,
              wnota: nota,
              widHogar: idHogar,
              mascotas: mascotas,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {
        comprobarDatos();
        _traerData();
      });
    });
  }

// 645
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
    if (estado == 2.toString()) {
      servicioFinalizado = false;
    }
    //Cargar hogares
    _cargarHogares() async {
      var provider = new HogarProvider();
      var hogares = await provider.hogarListar();
      hogares.forEach((hogar) {
        if (hogar['usuario_rut'].toString() == rut.toString()) {
          setState(() {
            _hogares.add(DropdownMenuItem(
                child: Text(hogar['direccion']), value: hogar['id']));
          });
        }
      });
    }

    _cargarHogares();
  }

// 702
  _traerData() async {
    var provider = PeticionProvider();
    var peticiones = await provider.peticionListar();
    var providerPublicacion = PublicacionProvider();
    var publicaciones = await providerPublicacion.publicacionListar();

    var condicional = 0;
    for (var peticion in peticiones) {
      // AGREGAR OTRA VALIDACION: QUE PETICION['FECHA_INICIO'] == HOY //
      if (peticion['estado'] == 2 ||
          peticion['estado'] == 5 ||
          peticion['estado'] == 6 ||
          peticion['estado'] == 7) {
        condicional = 1;
        // buscamos si es el dueño
        DateTime today = DateTime.now();
        DateTime fechaFin = DateTime.tryParse(peticion['fecha_fin']);
        if (peticion['estado'] == 7 && fechaFin.compareTo(today) < 0) {
          provider.peticionTerminada(peticion['id'].toString(), '4');
        }
        if (peticion['usuario_rut'].toString() == rut) {
          servicioFinalizado = false;
          tipoUsuario = 1;
          idData = peticion['id'];
          nota = peticion['nota'];
          estadoPeticion = peticion['estado'];
          var peticionMascota = await provider.mascotasPeticion(peticion['id']);
          mascotas = peticionMascota['mascotas'];
          for (var publicacion in publicaciones) {
            if (publicacion['id'] == peticion['publicacion_id']) {
              rutOtro = publicacion['usuario_rut'];
              idDataPublicacion = publicacion['id'];
              idHogar = publicacion['hogar_id'];
              DateTime fechaFin = DateTime.parse(peticion['fecha_fin']);
              var today = DateTime.now();
              if (fechaFin.compareTo(today) < 0) {
                _ultimoDia = true;
              }
            }
          }
        }
        // buscamos si es el cuidador
        for (var publicacion in publicaciones) {
          if (publicacion['usuario_rut'].toString() == rut &&
              publicacion['id'] == peticion['publicacion_id']) {
            tipoUsuario = 2;
            servicioFinalizado = false;
            for (var peticion in peticiones) {
              if (publicacion['id'] == peticion['publicacion_id']) {
                if (peticion['estado'] == 2 ||
                    peticion['estado'] == 5 ||
                    peticion['estado'] == 6 ||
                    peticion['estado'] == 7) {
                  idDataPublicacion = publicacion['id'];
                  idHogar = publicacion['hogar_id'];
                  rutOtro = peticion['usuario_rut'];
                  idData = peticion['id'];
                  var peticionMascota =
                      await provider.mascotasPeticion(peticion['id']);
                  mascotas = peticionMascota['mascotas'];
                  estadoPeticion = peticion['estado'];
                  nota = publicacion['nota'];
                  DateTime fechaFin = DateTime.parse(peticion['fecha_fin']);
                  var today = DateTime.now();
                  if (fechaFin.compareTo(today) < 0) {
                    _ultimoDia = true;
                  }
                }
              }
            }
          }
        }
      } else {
        if (condicional == 0) {
          tipoUsuario = null;
          idData = null;
          idDataPublicacion = null;
          idHogar = null;
          rutOtro = null;
          estadoPeticion = null;
          nota = null;
          mascotas = null;
        }
      }
    }
  }
}

void _navegarAlertas(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => AlertaListarPage());
  Navigator.push(context, route);
}

_navegarUbicaciones(BuildContext context) {
  var route =
      new MaterialPageRoute(builder: (context) => UbicacionesListarPage());
  Navigator.push(context, route);
}

_navegarNegocios(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => NegociosListarPage());
  Navigator.push(context, route);
}

void _navegarCuidado(BuildContext context) {
  var route = new MaterialPageRoute(builder: (context) => CuidadoPage());
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
